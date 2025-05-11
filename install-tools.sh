#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="install-tools.log"
SUMMARY_FILE="${SUMMARY_FILE:-install-summary.json}"
VERSIONS_FILE="${VERSIONS_FILE:-.tool-versions.json}"
DRY_RUN=false
INSTALL_TOOLS=(all)

# Check for dry-run and tool filter
for arg in "$@"; do
  case $arg in
    --dry-run)
      DRY_RUN=true
      echo "[Dry Run] No changes will be made. Commands will be printed only."
      ;;
    --tools=*)
      IFS=',' read -ra INSTALL_TOOLS <<< "${arg#*=}"
      ;;
    --summary-path=*)
      SUMMARY_FILE="${arg#*=}"
      ;;
  esac
done

exec > >(tee -a "$LOG_FILE") 2>&1

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SUMMARY_JSON="{}"
EXPECTED_JSON="{}"

if [[ -f "$VERSIONS_FILE" ]]; then
  EXPECTED_JSON=$(<"$VERSIONS_FILE")
fi

log_step() {
    echo -e "\n${YELLOW}🔧 $(date '+%Y-%m-%d %H:%M:%S') - $1${NC}"
}

run_cmd() {
    log_step "$1"
    shift
    if $DRY_RUN; then
        echo "[Dry Run] $*"
    else
        if "$@"; then
            echo -e "${GREEN}✅ Success: $1${NC}"
        else
            echo -e "${RED}❌ Failed: $1${NC}"
            exit 1
        fi
    fi
}

add_summary() {
  local name=$1
  local version=$2
  SUMMARY_JSON=$(echo "$SUMMARY_JSON" | jq --arg name "$name" --arg ver "$version" '. + {($name): $ver}')

  local expected_version
  expected_version=$(echo "$EXPECTED_JSON" | jq -r --arg name "$name" '.[$name] // empty')

  if [[ -n "$expected_version" && "$version" != "$expected_version" ]]; then
    echo -e "${RED}⚠️ Version mismatch for $name: expected $expected_version, got $version${NC}"
  fi
}

should_run() {
    [[ " ${INSTALL_TOOLS[*]} " =~ " all " || " ${INSTALL_TOOLS[*]} " =~ " $1 " ]]
}

# Installation steps below...
# [Unchanged block here, skipping for brevity]

if should_run terraform; then
  log_step "Installing Terraform"
  if ! $DRY_RUN; then
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  fi
  run_cmd "Update apt & install terraform" sudo apt-get update && sudo apt-get install -y terraform
  if ! $DRY_RUN; then
    TERRAFORM_VERSION=$(terraform version -json | jq -r .terraform_version)
    add_summary terraform "$TERRAFORM_VERSION"
  fi
fi

# Example for tfsec
if should_run tfsec; then
  log_step "Installing TFSec"
  run_cmd "Download tfsec" curl -sLo tfsec https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-$(uname)-amd64
  if ! $DRY_RUN; then
    chmod +x tfsec && sudo mv tfsec /usr/local/bin/
    TFSEC_VERSION=$(tfsec --version | awk '{print $3}')
    add_summary tfsec "$TFSEC_VERSION"
  fi
fi

# [Repeat for others as needed...]

if ! $DRY_RUN; then
  echo "$SUMMARY_JSON" | jq . > "$SUMMARY_FILE"
  echo -e "\n${GREEN}📦 Tool summary written to $SUMMARY_FILE${NC}"
fi

echo -e "\n${GREEN}✅ All tools installed successfully at $(date '+%Y-%m-%d %H:%M:%S')${NC}"

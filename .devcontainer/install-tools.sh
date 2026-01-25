#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="install-tools.log"
SUMMARY_FILE="${SUMMARY_FILE:-install-summary.json}"
VERSIONS_FILE="${VERSIONS_FILE:-.devcontainer/.tool-versions.json}"
DRY_RUN=false
INSTALL_TOOLS=(all)

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

get_expected_version() {
  local name=$1
  echo "$EXPECTED_JSON" | jq -r --arg name "$name" '.[$name] // empty'
}

should_run() {
  [[ " ${INSTALL_TOOLS[*]} " =~ " all " || " ${INSTALL_TOOLS[*]} " =~ " $1 " ]]
}

# OS dependencies
log_step "Installing OS dependencies"
run_cmd "Install OS dependencies" sudo apt-get update -y && sudo apt-get install -y \
  curl unzip git jq gnupg software-properties-common ca-certificates lsb-release tar build-essential apt-transport-https

# Terraform
if should_run terraform; then
  log_step "Installing Terraform"
  version=$(get_expected_version terraform)
  version="${version:-1.14.3}"
  if ! $DRY_RUN; then
    run_cmd "Download Terraform" curl -sLo terraform.zip "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip"
    run_cmd "Unzip Terraform" unzip -o terraform.zip
    run_cmd "Move Terraform" sudo mv terraform /usr/local/bin/
    rm -f terraform.zip
  fi
  TERRAFORM_VERSION=$(terraform version -json | jq -r .terraform_version)
  add_summary terraform "$TERRAFORM_VERSION"
fi

# AWS CLI
if should_run awscli; then
  log_step "Installing AWS CLI"
  run_cmd "Download AWS CLI" curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  run_cmd "Unzip AWS CLI" unzip -o awscliv2.zip
  run_cmd "Install AWS CLI" sudo ./aws/install --update
  rm -rf awscliv2.zip aws
  AWS_VERSION=$(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)
  add_summary awscli "$AWS_VERSION"
fi

# tflint
if should_run tflint; then
  log_step "Installing tflint"
  if ! $DRY_RUN; then
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
  fi
  TFLINT_VERSION=$(tflint --version 2>/dev/null | head -n1 | awk '{print $3}' || echo "installed")
  add_summary tflint "$TFLINT_VERSION"
fi

# tfsec
if should_run tfsec; then
  log_step "Installing tfsec"
  version=$(get_expected_version tfsec)
  version="${version:-1.28.5}"
  if ! $DRY_RUN; then
    run_cmd "Download tfsec" curl -sLo tfsec "https://github.com/aquasecurity/tfsec/releases/download/v${version}/tfsec-linux-amd64"
    run_cmd "Move tfsec" sudo mv tfsec /usr/local/bin/
    run_cmd "Make tfsec executable" sudo chmod +x /usr/local/bin/tfsec
  fi
  TFSEC_VERSION=$(tfsec --version 2>/dev/null || echo "installed")
  add_summary tfsec "$TFSEC_VERSION"
fi

# terraform-docs
if should_run terraform-docs; then
  log_step "Installing terraform-docs"
  version=$(get_expected_version terraform-docs)
  version="${version:-0.18.0}"
  if ! $DRY_RUN; then
    run_cmd "Download terraform-docs" curl -sLo terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/v${version}/terraform-docs-v${version}-linux-amd64.tar.gz"
    run_cmd "Extract terraform-docs" tar -xzf terraform-docs.tar.gz
    run_cmd "Move terraform-docs" sudo mv terraform-docs /usr/local/bin/
    rm -f terraform-docs.tar.gz
  fi
  TFDOCS_VERSION=$(terraform-docs --version 2>/dev/null | awk '{print $3}' || echo "installed")
  add_summary terraform-docs "$TFDOCS_VERSION"
fi

# pre-commit
if should_run pre-commit; then
  log_step "Installing pre-commit"
  if ! $DRY_RUN; then
    run_cmd "Install Python pip" sudo apt-get install -y python3-pip
    run_cmd "Install pre-commit" sudo pip3 install --break-system-packages pre-commit
  fi
  PRECOMMIT_VERSION=$(pre-commit --version 2>/dev/null | awk '{print $2}' || echo "installed")
  add_summary pre-commit "$PRECOMMIT_VERSION"
fi

# checkov (alternative to tfsec)
if should_run checkov; then
  log_step "Installing checkov"
  if ! $DRY_RUN; then
    run_cmd "Install Python pip" sudo apt-get install -y python3-pip
    run_cmd "Install checkov" sudo pip3 install --break-system-packages checkov
  fi
  CHECKOV_VERSION=$(checkov --version 2>/dev/null || echo "installed")
  add_summary checkov "$CHECKOV_VERSION"
fi

# Node.js (for semantic-release)
if should_run nodejs; then
  log_step "Installing Node.js"
  if ! $DRY_RUN; then
    if command -v node &> /dev/null; then
      log_step "Node.js already installed, ensuring npm is available"
      if ! command -v npm &> /dev/null; then
        run_cmd "Install npm" sudo apt-get update && sudo apt-get install -y npm
      fi
    else
      version=$(get_expected_version nodejs)
      version="${version:-22}"
      run_cmd "Download NodeSource setup script" curl -fsSL https://deb.nodesource.com/setup_${version}.x -o nodesource_setup.sh
      run_cmd "Run NodeSource setup" sudo -E bash nodesource_setup.sh
      run_cmd "Install Node.js and npm" sudo apt-get install -y nodejs
      rm -f nodesource_setup.sh
    fi
  fi
  NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//')
  NPM_VERSION=$(npm -v 2>/dev/null || echo "not installed")
  add_summary nodejs "$NODE_VERSION"
  add_summary npm "$NPM_VERSION"
fi

# Go (for terratest)
if should_run go; then
  log_step "Installing Go"
  version=$(get_expected_version go)
  version="${version:-1.21.0}"
  if ! $DRY_RUN; then
    run_cmd "Download Go" curl -sLo go.tar.gz "https://go.dev/dl/go${version}.linux-amd64.tar.gz"
    run_cmd "Extract Go" sudo tar -C /usr/local -xzf go.tar.gz
    rm -f go.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/go.sh
    export PATH=$PATH:/usr/local/go/bin
  fi
  GO_VERSION=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//' || echo "installed")
  add_summary go "$GO_VERSION"
fi

# Write summary
if ! $DRY_RUN; then
  echo "$SUMMARY_JSON" | jq . > "$SUMMARY_FILE"
  echo -e "\n${GREEN}📦 Tool summary written to $SUMMARY_FILE${NC}"
fi

echo -e "\n${GREEN}✅ All tools installed successfully at $(date '+%Y-%m-%d %H:%M:%S')${NC}"

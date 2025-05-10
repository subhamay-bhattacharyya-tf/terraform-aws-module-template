#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Installing OS dependencies..."
sudo apt-get update -y
sudo apt-get install -y \
    curl \
    unzip \
    git \
    jq \
    gnupg \
    software-properties-common \
    ca-certificates \
    lsb-release \
    tar


# Install Python and pip (if not already installed)
echo "🔧 Installing Python.."
sudo apt-get install -y python3 python3-pip

# Install pre-commit
echo "🔧 Installing pre-commit..."
pip3 install --upgrade pip
pip3 install pre-commit

# Optionally verify installation
echo "🔧 Verifying pre-commit installation..."
pre-commit --version

# Install the Git hook scripts
echo "🔧 Install git hook scripts."
pre-commit install


echo "🔧 Installing Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform

echo "🔧 Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install
rm -rf awscliv2.zip aws

echo "🔧 Installing Terraform Docs v0.12.0..."
curl -sLo terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.12.0/terraform-docs-v0.12.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
sudo mv terraform-docs /usr/local/bin/
rm terraform-docs.tar.gz

echo "🔧 Installing Terragrunt..."
TG_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq -r .tag_name)
curl -Lo terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_$(uname -s)_amd64
chmod +x terragrunt && sudo mv terragrunt /usr/local/bin/

echo "🔧 Installing Terrascan..."
curl -s https://runterrascan.io/install.sh | bash
sudo mv terrascan /usr/local/bin/

echo "🔧 Installing TFLint..."
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
sudo mv tflint /usr/local/bin/

echo "🔧 Installing TFSec..."
curl -sLo tfsec https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-$(uname)-amd64
chmod +x tfsec && sudo mv tfsec /usr/local/bin/

echo "🔧 Installing Trivy..."
TRIVY_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | jq -r .tag_name)
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin ${TRIVY_VERSION}

echo "🔧 Installing Infracost..."
curl -s https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
sudo mv infracost /usr/local/bin/

echo "🔧 Installing tfupdate..."
go install github.com/minamijoyo/tfupdate@latest
sudo mv ~/go/bin/tfupdate /usr/local/bin/

echo "🔧 Installing hcledit..."
go install github.com/minamijoyo/hcledit@latest
sudo mv ~/go/bin/hcledit /usr/local/bin/

echo "✅ All tools installed successfully!"

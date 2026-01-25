FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    jq \
    software-properties-common \
    gnupg \
    lsb-release \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy and run install script
COPY install-tools.sh /usr/local/bin/install-tools.sh
RUN chmod +x /usr/local/bin/install-tools.sh && /usr/local/bin/install-tools.sh

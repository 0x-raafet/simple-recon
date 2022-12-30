#!/bin/bash

# Exit immediately if any command returns a non-zero exit code
set -e

# Check if the 'go' command is available
if ! command -v go > /dev/null; then
  # Go is not installed, so install it
  echo "Go is not installed. Installing Go..."

  # Check if the Go installer has already been downloaded
  if [ ! -f go.tar.gz ]; then
    # Download the Go installer
    wget https://golang.org/dl/go1.15.linux-amd64.tar.gz -O go.tar.gz
  fi

  # Extract the Go installer
  tar -xzf go.tar.gz

  # Install Go to /usr/local
  sudo mv go /usr/local

  # Set the GOPATH environment variable
  export GOPATH=$HOME/go

  # Add Go to the PATH
  export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

  # Clean up the installer files
  rm go.tar.gz
fi

# Set the GO111MODULE environment variable
export GO111MODULE=auto

# Create a map of package names and URLs
declare -A packages=(
  ["assetfinder"]="github.com/tomnomnom/assetfinder"
  ["subfinder"]="github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
  ["amass"]="github.com/OWASP/Amass/v3/...@master"
  ["subzy"]="github.com/lukasikic/subzy@latest"
  ["nuclei"]="github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
  ["httpx"]="github.com/projectdiscovery/httpx/cmd/httpx@latest"
  ["crlfuzz"]="github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest"
  ["html"]="golang.org/x/net/html"
  ["titlextractor"]="github.com/dellalibera/titlextractor/"
)

# Iterate over the map and install the packages
for package in "${!packages[@]}"; do
  if go get -u "${packages[$package]}" -v; then
    echo "Install $package [DONE]"
  else
    echo "Install $package [FAILED]"
  fi
done

echo "DONE"

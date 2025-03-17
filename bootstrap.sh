echo "Determining shell"
if echo $SHELL | grep -q 'bash'; then
    shell=~/.bashrc
elif echo $SHELL | grep -q 'zsh'; then
    shell=~/.zshrc
else
    echo "Unable to determine shell. Exiting"
    exit 1
fi
echo "Shell = " $SHELL

echo "Determining machine architecture"
if dpkg --print-architecture | grep -q 'amd64'; then
    architecture='amd64'
elif dpkg --print-architecture | grep -q 'arm64'; then
    architecture='arm64'
elif dpkg --print-architecture | grep -q '86'; then
    architecture='x86'
else
    echo "Unable to determine architecture. Please install Go manually. Exiting."
    exit 1
fi
echo "Architecture = " $architecture

# Golang install
echo "Go 1.24.1 Installation"
if echo $architecture | grep -q 'amd64' ; then
    wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz
elif echo $architecture | grep -q 'arm64'; then
    wget https://go.dev/dl/go1.24.1.linux-arm64.tar.gz
    tar -C /usr/local -xzf go1.24.1.linux-arm64.tar.gz
elif echo $architecture | grep -q 'x86'; then
    wget https://go.dev/dl/go1.24.1.linux-386.tar.gz
    tar -c /usr/local -xzf go1.24.1.linux-386.tar.gz
fi
export PATH=$PATH:/usr/local/go/bin
echo "Confirm go installation"
go version

# NVM install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source $shell
echo "Confirm NVM installation"
nvm -v

# NPM install
nvm install 18
echo "Confirm NPM version"
node --version

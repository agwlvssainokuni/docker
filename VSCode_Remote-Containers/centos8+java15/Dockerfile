FROM centos:centos8

RUN dnf install -y git wget which unzip zip \
    && useradd vscode \
    && (curl -s https://get.sdkman.io | su vscode -c bash) \
    && (curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | su vscode -c bash) \
    && su vscode -c '. ${HOME}/.sdkman/bin/sdkman-init.sh && sdk install java 15.0.1-open' \
    && su vscode -c '. ${HOME}/.nvm/nvm.sh && nvm install --lts'

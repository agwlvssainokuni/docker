FROM centos:centos8

RUN dnf groupinstall -y "Development Tools" \
    && dnf install -y wget openssl-devel \
    && useradd vscode \
    && (su vscode -c 'git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv') \
    && (su vscode -c 'cd ${HOME}/.rbenv && ./src/configure && make -C src') \
    && (su vscode -c 'mkdir -p ${HOME}/.rbenv/plugins && git clone https://github.com/rbenv/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build') \
    && (su vscode -c 'echo export PATH=\${HOME}/.rbenv/bin:\${PATH} >> ${HOME}/.bashrc') \
    && (su vscode -c 'echo eval \"\$\(rbenv init -\)\" >> ${HOME}/.bashrc') \
    && (curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | su - vscode -c bash) \
    && (su vscode -c '. ${HOME}/.bashrc && rbenv install 2.7.2 && rbenv global 2.7.2')

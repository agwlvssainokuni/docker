開発用メールサーバ
--------------------

## 概要
CentOS 8 (centos:centos8) および Ubuntu 20.04 LTS (ubuntu:20.04)
をベースとし「メールが外に出ていかない」ことを特徴とするメールサーバの
コンテナイメージを作成する。

メールの誤送信リスクを低減し、開発用に使用することを想定する。

## 構成
### Postfix
- プロトコル
  - SMTP (25)
  - SMTP (587) (サブミッションポート)
  - SMTPs (465)
  - STARTTLS対応
  - SMTP AUTH対応(PLAIN)
- DNS照会を抑止するとともに、全ての転送先をlocalとすることで、外に
  出ていかないよう制御。

### Dovecot
- プロトコル
  - POP3s (995)
  - IMAP4s (993)

### rsyslog
- メール送信ログをSYSLOGに記録する。

### OpenSSH
- メンテナンスを目的として、外部からSSHログインできるよう構成しておく。

## Docker操作
### ビルド
    docker build -t devmailsv:centos8 centos8
    docker build -t devmailsv:ubuntu2004 ubuntu2004

### 起動
    docker run -d -p 22:22 -p 25:25 -p 465:465 -p 587:587 -p 993:993 -p 995:995 --name=${name} devmailsv:centos8
    docker run -d -p 22:22 -p 25:25 -p 465:465 -p 587:587 -p 993:993 -p 995:995 --name=${name} devmailsv:ubuntu2004

### 初期構成
    docker exec ${name} mkdir /root/.ssh/
    docker cp ${HOME}/.ssh/id_rsa.pub ${name}:/root/.ssh/authorized_keys
    docker exec ${name} chmod -R go-rwx /root/.ssh/

以上。

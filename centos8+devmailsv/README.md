開発用メールサーバ
--------------------

## 概要
CentOS 8 (centos:centos8) をベースとし「メールが外に出ていかない」
ことを特徴とするメールサーバのコンテナイメージを作成する。

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
### ビルド方法
    docker build -t devmailsv -f Dockerfile .

### 実行方法
    docker run -d -P --privileged devmailsv

以上。

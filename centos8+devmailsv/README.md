開発用メールサーバ
--------------------

## 概要
CentOS 8 (centos:centos8) をベースとし「メールが外に出ていかない」
ことを特徴とするメールサーバのコンテナイメージを作成する。

メールの誤送信リスクを低減し、開発用に使用することを想定する。

## 構成
### Postfix
- プロトコル
  - SMTP (25, 587)
  - SMTPs (465)
- SMTP認証対応あり (Dovecot連携)
- DNS照会を抑止するとともに、全ての転送先をlocalとすることで、外に
  出ていかないよう制御。

### Dovecot
- プロトコル
  - POP3 (110)
  - POP3s (995)
  - IMAP4 (143)
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

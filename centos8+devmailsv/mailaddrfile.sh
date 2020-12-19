#!/bin/bash

########################################################################
# コマンドラインオプション解析
usage_and_exit() {
    echo "Usage: $0 [options] file..." 1>&2
    echo "  -f  USER NUM FROM (default: 0)" 1>&2
    echo "  -t  USER NUM TO (default: 1000)" 1>&2
    echo "  -u  USERNAME PREFIX (default: user)" 1>&2
    echo "  -p  PASSWORD PREFIX (default: user)" 1>&2
    exit $1
}

do_fm=0
do_to=1000
do_user=user
do_pass=user

while getopts f:t:u:p:h OPT; do
    case $OPT in
    f) do_fm=${OPTARG};;
    t) do_to=${OPTARG};;
    u) do_user=${OPTARG};;
    p) do_pass=${OPTARG};;
    h) usage_and_exit 0;;
    \?) usage_and_exit -1;;
    esac
done
shift $((OPTIND - 1))

########################################################################
# 主処理
seq -w ${do_fm} ${do_to} | while read n; do
    echo ${do_user}${n}:${do_pass}${n}
done

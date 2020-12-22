#!/bin/bash

cd $1

sh buildconf
./configure --with-apxs=/usr/bin/apxs
make
cp -p *.so /usr/lib/apache2/modules/

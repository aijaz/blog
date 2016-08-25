#!/bin/bash

# create some variables, to reduce the risk of typos
PACKAGE=/usr/local/down/new
HTTPSRC=httpd-2.2.22
HTTPTAR=httpd-2.2.22.tar.gz
PREFIX=/usr/local/apache2

cd $PACKAGE

# always start with a clean slate
/bin/rm -rf $HTTPSRC

tar -xzf $HTTPTAR
cd $HTTPSRC

# configure apache using dynamically linked modules
# and the apr and apr-util packages I installed in /usr/local
#
# This will install apache in the default location: /usr/local/apache2
./configure \
	--enable-so \
	--prefix=$PREFIX \
	--with-mpm=prefork \
	--enable-rewrite=shared \
	--enable-expires=shared \
	--enable-headers=shared \
	--enable-ssl=shared \
	--enable-deflate=shared \
	--with-apr=/usr/local/apr \
	--with-apr-util=/usr/local/apr-util \
|| { echo "** CONFIG FAILED"; exit 1; }


make install || { echo "** MAKE FAILED"; exit 1; }

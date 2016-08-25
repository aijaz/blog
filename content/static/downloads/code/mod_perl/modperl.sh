#!/bin/bash

# create some variables, to reduce the risk of typos
PACKAGE=/usr/local/down/new
MPSRC=mod_perl-2.0.7
MPTAR=mod_perl-2.0-current.tar.gz
PREFIX=/usr/local/apache2

cd $PACKAGE

# always start with a clean slate
/bin/rm -rf $MPSRC

tar -xzf $MPTAR
cd $MPSRC

# configure mod_perl telling it where to find apxs
perl Makefile.PL \
	MP_USE_DSO \
	MP_APXS=$PREFIX/bin/apxs \
|| { echo "** PERL MAKEFILE FAILED"; exit 1; }


make || { echo "** MAKE FAILED"; exit 1; }
make test || { echo "** MAKE FAILED"; exit 1; }
make install || { echo "** MAKE FAILED"; exit 1; }

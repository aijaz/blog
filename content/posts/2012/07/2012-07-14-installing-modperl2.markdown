title: "Installing mod_perl 2.0"
date: 2012-07-14 20:24
comments: false
Category: Computers
Tags: Apache, mod_perl, Perl, linux

I recently needed to upgrade one of my machines to mod_perl 2.0.  I
encountered many problems on the way, and would like to share with you
what I did to finally get it to work.

<!-- more -->

There are two things you should **not** do:

First, don't use httpd 2.4.2.  Some structures have changed, and mod_perl
doesn't support these changes.

Secondly don't attempt to statically link mod_perl into Apache - The
documentation is self-contradictory and just plain wrong.  Some people
have got it to work, but their results are not reproducible using the
steps they have documented. It suggest that their success was accidental.
Naturally, if you have gotten this to work and can reproduce these steps
reliably, please let me know via email ([MyFirstName]@[MyFirstName].net)
or Twitter, where I'm [@\_aijaz\_](http://www.twitter.com/_aijaz_).

Now that we've got that out the way, let's look at what worked.  I
downloaded and installed Perl 5.16.0:

    perl-5.16.0 33 # sh Configure -des && make && make test && make install

This will build perl without threads.

Before we can build apache, we have to install ```apr``` and
 ```apr-util```, both of which are Apache Portable Runtime libraries and are
available at [http://apr.apache.org](http://apr.apache.org).  I extracted
the tar files and installed the libraries in ```/usr/local/apr```
and ```/usr/local/apr-util```:

    # tar -xvzf apr-1.4.6.tar.gz 
    # tar -xzf apr-util-1.4.1.tar.gz
    # cd apr-1.4.6
    # ./configure --prefix=/usr/local/apr && make && make test && make install
    # cd ../apr-util-1.4.1
    # ./configure ---prefix=/usr/local/apr-util --with-apr=/usr/local/apr && make && make test && make install


To build Apache/mod_perl2 with shared modules, we have to first build and
install Apache and then configure and build mod_perl.  I created a
directory called ```/usr/local/down/new``` and downloaded 
 ```httpd-2.2.22.tar.gz``` and ```mod_perl-2.0-current.tar.gz``` into
them.  It is important that you chose mod_perl version 2.0.7, because that
is the version that works with perl 5.16.


I decided to create two scripts - one for installing apache, and the other
for mod_perl.  That way, if something didn't work, I could change the
script easily without introducing new typos.  And, I have a record of what
I did, making my steps reproducible.  Let's look at the first script,
called ```apache.sh``` which I saved in ```/usr/local/down/new```:

{% include_code mod_perl/apache.sh lang:bash %}

This script will install Apache in the default location of
 ```/usr/local/apache2``` with the modules that I want dynamically linked.
Note that I have to specify where to find ```apr``` and ```apr-util```.  

Now for the mod_perl script:

{% include_code mod_perl/modperl.sh lang:bash %}

I needed to tell mod_perl where to find the ```apxs``` executable (it's
installed in ```/usr/local/apache2/bin```).

Finally, I needed to modify ```httpd.conf``` by adding the line that
actually loads the shared mod_perl module: 
    
    LoadModule perl_module modules/mod_perl.so                                                                                             

And that was it.  It took a lot longer to get to this point than I was
expecting, but now that I have these scripts I have a simple way of
installing mod_perl in the future.  I hope you find this useful.    

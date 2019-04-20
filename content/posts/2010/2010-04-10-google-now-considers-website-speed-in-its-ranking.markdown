comments: false
date: '2010-04-10 14:55:15'
slug: google-now-considers-website-speed-in-its-ranking
title: Google Now Considers Website Speed In Its Ranking
Category: Computers
Tags: Apache, Firebug, Firefox, Google, HTTP, SEO, TaskForest, Websites, YUI

[Google reported yesterday](http://googlewebmastercentral.blogspot.com/2010/04/using-site-speed-in-web-search-ranking.html) that their search engine will
now include a website's speed in the list of factors it uses to decide how
high to rank the site in its search results.  In this post I consider what
this means for web developers and what steps you can take to make your site
faster.
<!-- more -->

Google has made it clear that speed is not the primary factor when determining
page rank:

> While site speed is a new signal, it doesn't carry as much weight as the
[relevance of a page](http://www.youtube.com/watch?v=muSIzHurn4U). Currently,
fewer than 1% of search queries are affected by the site speed signal in our
implementation and the signal for site speed only applies for visitors
searching in English on Google.com at this point.

It is, however, a turning point for web site developers.  What Google is
really doing is putting a tangible value on the User Experience.  A fast site
makes for a more satisfactory experience, and linking to fast sites also makes
users happier with Google.  I know how frustrating it is to see what appears
to be a promising search result on Google, only to find the site very sluggish
once I click through Google's recommendation.  So, like it or not, you and I
will now have to make sure we at least consider our sites' rendering speeds.

As I had mentioned in a [earlier post](/2010/03/31/performance-cost-of-using-wordpress/), I recently changed the taskforest.com
website to static HTML from a template-based system.   After reading Google's
blog entry, I installed [Firebug](http://getfirebug.com/) on Firefox, as well
as two different page performance measuring tools:
[PageSpeed](http://code.google.com/speed/page-speed/index.html) and [YSlow from Yahoo](http://developer.yahoo.com/yslow/) and started testing out the
TaskForest web site.  To my dismay, the site scored a paltry 76/100 on
PageSpeed and a 'D' (67/100) on YSlow.  I'm glad to say that in less than an
hour I was able to make the changes that most significantly improved my site's
speed.

There were four major areas in which the two tools recommended changes:

###Exploiting Browsers' Caches

The site was not using the Expires response headers. As [this document from Google](http://code.google.com/speed/page-speed/docs/caching.html) shows, proper usage of this HTTP header can greatly reduce load on the server as well as clients.The Expires header tells the client how long the server expects the resource to stay unchanged.  For images like logos and screenshots that don't change very often, this period could (and should) be as high as few months, possibly even the maximum allowed value - one year.  For HTML pages that change often, you could set it to 2-7 days. 
    
The taskforest site which was using Apache 1.41, was not sending the Expires HTTP response header. The reason is that the module that sets this, <em>mod_expires</em>, is not enabled by default. 

###Combining External CSS

The website was using three CSS style sheets.  One was my own 'styles.css,' but the other two were Yahoos YUI style sheets.  For every request for a web page, there were 3 additional requests for style sheets. 

###Combining External Javascript

Just like style sheets, There were 6 Javascript files that were being served with every page. 

###Using Compression

The website was not compressing the data it sent to the client.  As [this article](http://code.google.com/speed/articles/use-compression.html) and the video below from Google shows, data compression can have a major impact on the size of the payload the server delivers to the client, thus making the site faster.   

<iframe width="640" height="360" src="http://www.youtube.com/embed/Mjab_aZsdxw" frameborder="0" allowfullscreen></iframe>

<a name="optimizing"></a>
## Optimizing the site

So the first order of business was to enable <em>mod_expires</em> and install and
activate <em>mod_gzip</em>.  These are the Apache modules that enable the Expires
header and Response compression.  I reconfigured Apache with the ```--enable-module=expires``` and ```--activate-module=src/modules/gzip/mod_gzip.c``` options.
Previously, the relevant lines in my ```httpd.conf``` file looked like this:

~~~~{.apacheconf}
<VirtualHost 216.139.227.47>
 ServerName www.taskforest.com
 DocumentRoot ".../taskforest/htdocs/website"
</VirtualHost>
~~~~
  
After installing the two new modules, my httpd.conf file looked like this:

~~~~{.apacheconf}
<VirtualHost 216.139.228.44>
 ServerName www.taskforest.com
 DocumentRoot ".../taskforest/htdocs/website"  
 FileEtag None  

 # enable expirations
 ExpiresActive On  

 # unless overridden elsewhere resources expires
 # after 60 days in the client's cache
 #
 ExpiresDefault "access plus 60 days"  

 # The site's feed expires after 1 day in the cache
 ExpiresByType application/xml A86400  

 # HTML files expire after 1 day in the cache
 ExpiresByType text/html A86400  

 # Turn compressing on
 mod_gzip_on Yes  

 # Don't bother compressing tiny files
 mod_gzip_minimum_file_size  1002  
 mod_gzip_maximum_file_size  0
 mod_gzip_maximum_inmem_size 60000  

 # Compress XML files, text files (including HTML)
 # and directory listings
 mod_gzip_item_include mime "application/xml"
 mod_gzip_item_include mime text/*
 mod_gzip_item_include mime "httpd/unix-directory"  

 # Compress files based on their names as well
 mod_gzip_item_include file "\.txt$"
 mod_gzip_item_include file "\.html$"
 mod_gzip_item_include file "\.css$"
 mod_gzip_item_include file "\.js$"  
 mod_gzip_dechunk Yes
 mod_gzip_temp_dir "/tmp"
 mod_gzip_keep_workfiles No  
</VirtualHost>

<VirtualHost 216.139.228.44>
 ServerName taskforest.com
 RedirectMatch (.*) http://www.taskforest.com$1
</VirtualHost>  
~~~~    

For the multiple CSS files, I just copied both of the YUI  style sheets into
my styles.css file, preserving the copyright comments.  As for the YUI
javascript files, it turns out that none of them were being used!  They were
just copied and pasted from the taskforestd webserver web site, which does use
the javascript files.  I was able to delete them altogether.  It was rather
embarrassing to realize that the site was serving unused files.  But I was
glad to have the tools that helped me realize this.

### Results of Optimization

The results of the optimization were startling.  The PageTest scores
originally looked like this:

<!-- ai c /wp/PageSpeedOrig.png /wp/PageSpeedOrig.png 375 436 PageSpeed Results Before Optimization -->

Now, after the optimization, the report was much more respectable:

<!-- ai c /wp/PageSpeed.png /wp/PageSpeed.png 447 473 PageSpeed Results After Optimization -->

This exercise gave me new insight into what is needed to make a website
faster.  It's not just the fastest machine and the most optimized database
that matters.  One also has to consider the fundamental characteristics of the
Web, and HTTP in particular, where a little effort can bring significant
improvement.

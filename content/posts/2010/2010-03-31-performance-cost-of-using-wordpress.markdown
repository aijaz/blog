comments: false
date: '2010-03-31 12:57:48'
slug: performance-cost-of-using-wordpress
title: The Performance Cost of Using WordPress
description: I've come to the conclusion that, at least for TaskForest, WordPress would cause more problems than it would solve.
Category: Computers
Tags: Apache, Caching, DNS, Efficiency, Etag, HTTP, Metrics, Programming, Safari Web Browser, Spiders, TaskForest, Testing, Websites, WordPress

Happy with my experience with a custom WordPress installation for this blog, I
decided to try using the blogging platform for the
[TaskForest](http://www.taskforest.aijaz.net/) website.  The two main reasons were
the ease of creating RSS feeds and the ability for users to comment on posts
or articles.  After a few days of tinkering around, I've come to the
conclusion that, at least for TaskForest, WordPress would cause more problems
than it would solve. Here's how I came to that conclusion:
<!-- more -->

### Setting up a Sandbox Domain

The first step in trying out WordPress was to set up a new domain just for
testing out the WordPress installation.  This way, I wouldn't affect the
taskforest.aijaz.net domain during my experiments.  I happen to run my own name
servers using Daniel Bernstein's [_tinydns_](http://cr.yp.to/djbdns.html), so
I decided to create a new domain called _tf.enoor.com_, a subdomain of my
defunct company's domain.  Since I use bluehost.com's WordPress hosting
service, I had to make their name servers responsible for the domain.  All
that's needed is adding the following two lines to _/etc/tinydns/root/data_:

    
    
    &tf.enoor.com:74.220.195.31:ns1.bluehost.com:300
    &tf.enoor.com:69.89.16.4:ns2.bluehost.com:300
    

### Selecting a Theme

After setting up WordPress, the next step was to select a theme.  I wanted
something similar to TaskForest's current design, so I chose the remarkably
customizable [Suffusion](http://www.aquoid.com/news/themes/suffusion/) theme.
After some tinkering I was able to get a site that was quite similar to the
original, with one compromise - I could get either the logo or the site's name
in the header, but not both.  Not the way they are on the current site.  It's
quite important that the site's name appear in the header, because that helps
with Search Engine Ranking.  So with a heavy heart I decided to omit the logo.

## The Problem with Content

TaskForest ships with its own web server to support
[REST](http://en.wikipedia.org/wiki/Representational_State_Transfer)
interface.  As part of the included website is all the documentation for the
system. Just like the code, this documentation is under source control, and
it's also used to populate the taskforest.aijaz.net website.  This way, I can ensure
that both the taskforest.aijaz.net website and a user's local install have the most
up-to-date docs, as long as the user is running the latest version of the
software.  What this also means is that I have a few dozen webpages that need
to be transfered to WordPress before the new site can go live.  I was already
resigned to the fact that the URLs of these pages would be different - the
current site has URLs that look like _http://www.taskforest.aijaz.net/about.html_,
but the default WordPress installation would use URLs that look like
_http://www.taskforest.aijaz.net/about/_.  It's not a huge deal, but I prefer my
way.

The bigger issue is that when a new version of the software is released, the
pages change.  The current build process ensures that the client website and
the taskforest.aijaz.net website stay in sync.  Now if I use WordPress, I don't want
to manually edit the pages using the WP admin site.  I need to install a new
plugin that handles inclusion of files.  So, I installed the WP Include
plugin.  I'd have to change my build process, but I could get it to work.

### Putting It All Together

Okay, so I got the themes and plugins installed, and I've got the process
worked out.  It was then time to try a proof of concept with a single page.
It worked just as expected, but the site seemed very sluggish.  I made sure I
didn't have anything enabled that I didn't need.  Still, the site was
noticeably slower than the existing site, and that's with only one non-blank
page and zero blog posts.  I thought that maybe the problem was that the
bluehost.com shared server was too slow.  I just happened to have an unused
server in the same data center that hosts taskforest.aijaz.net.  The same kind of
server as well. It took the better part of the morning, but I installed PHP,
mysql and WordPress on that server.  In installed PHP as a static module
within Apache, for optimal performance.  Even then, on a pristine machine
running nothing else, it was **slow**.

### How Slow is Slow?

Anyone who knows me knows that I'm an Engineer, and as an Engineer I like
metrics.  I wanted to know that it wasn't just my own bias that was penalizing
WordPress over my established way of doing things.  So, I looked at the Safari
web browser on the Mac.  Safari has a really useful feature called the Web
Inspector that, among other things, displays the amount of time it takes for
different parts of a page to load.  The numbers were very surprising.  With
WordPress, a new page would take **1.75** seconds to load - an eternity on a
high-speed broadband connection.  A subsequent request of the same page would
take about **700ms**. Switching to the TaskForest website's strategy would
take about **800ms** for a new page, and **275ms** for a cached page.  That's
more than a **20****0%** increase in speed!  The TaskForest website used a
preprocessor that allowed for including header files.  It ran under mod_perl.
I decided to write a spider that crawled the website and convert everything to
static pages, and serve those pages without mod_perl.  With this enhancement,
the results were even better.  I saw a **400% to 800% speed increase**, with
cached pages taking just **140ms** to load.

One of the reasons WordPress's numbers were so poor is that if articles like
[this one](http://www.codinghorror.com/blog/2008/04/behold-wordpress-destroyer-of-cpus.html) are still correct, WordPerfect does not cache the
content of pages by default.  Resources within the HTML page, like images or
javascript files seem to be cached, but every page still does upto 120
database accesses depending on the setup.  Apache is a lot better at caching
requests for static HTML pages.  Even the TaskForest webserver used for the
REST API, caches data very intelligently using the HTTP headers.

### What Does This All Mean?

Given the amount of compromises I would have to make in the design, layout and
build process, switching to WordPress would have been very painful.  However,
with the performance hit the site would be taking, it seems unlikely that I'll
switch to WP any for the TaskForest website any time soon.  I think I'd rather
write a script to generate RSS feeds on demand and automatically submit the
feed to feed notification sites like pingomatic. I think this was a great
learning experience that will help me with similar decisions in the future.
And I also got to write a cool spider and increase the speed of the TaskForest
web site.

<!-- ai c /wp/WebInspector.png /wp/WebInspector-585x351.png 585 351 Safari's Web Inspector -->

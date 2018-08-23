---
title: "Switching To Octopress"
date: 2011-12-12 08:19
comments: false
Category: Computers
tags: 
 - Octopress
 - WordPress
 - Analytics
---

Over this past weekend I switched my blog over from WordPress to
Octopress.  In this post I write about why I did it, what exactly I did
to get the blog just the way I wanted, and what I plan to do in the
future.

<!-- more -->

If you were to ask me what's the difference between the two,
the first thing I would tell you is that Octopress serves static HTML.
The blog is generated on my local machine (usually my laptop) and then
the static files are uploaded to the server.  This is also called
'baking the site.' 

While I'm not an 'A-list' blogger and don't have to worry about my site
being Fireballed or Slashdotted (or JessicaHisched or SwissMissed) it's
comforting to know that my blog is being served as efficiently as it can
be. 

A lot has been said about the virtues of baking your own blogs, so I'm
not gonna repeat them here.  You can 
[read what Matt Gemmell had to say about it](http://mattgemmell.com/2011/09/12/blogging-with-octopress/) and also 
what Brent Simmons wrote about it in 
[these](http://inessential.com/2009/01/30/new_publishing_system_tour_of_my_head)
[three](http://inessential.com/2011/03/16/a_plea_for_baked_weblogs)
[articles](http://inessential.com/2011/03/17/more_on_baked_blogs).

For me, though, the biggest motivating factor was that I didn't like
using the Wordpress website to create and edit blog posts.  The web
interface is just not natural.  Yes, there are apps like MarsEdit that
simplify the process, but that's still one more layer of abstraction
than I care to interact with.  I want the experience of writing to be as
close to the metal as possible: I use a [text editor](/2010/01/26/why-text-editors-matter)
to edit text - I should be able to use any text editor to edit my blog.  

Enter Octopress and its support of [Markdown](http://daringfireball.net/projects/markdown/).  I set up Octopress
per [Matt's recommendations](http://daringfireball.net/projects/markdown/) and with some minor hacking I was able
to migrate the blog over the course of one weekend.  In what's left of
this post I'll write about what changes I made to the system to get the
blog 'just right' and what changes I would like to make in the future.  

### Floating Images

Octopress has a nice shorthand for specifying images:

~~~~{.HTML}
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}
~~~~

Using the proper class names one can have the image float left or right
or otherwise set its alignment.  However, I like having captions under
my images.  This requires a floating div that would contain both the image
and the caption under it.  For best results, the div would have to be
about as wide as the image.  

Octopress is based on [Jekyll](http://jekyllrb.com) that supports the 
[Liquid template engine written in ruby](http://liquidmarkup.org/).  
I could probably have written a Liquid
plugin to do this, but I don't know Ruby (yet) and so I had to come up
with another solution.

To get this to work I created my own markup that would be inserted into
the markdown text as an HTML comment.  Markdown would preserve the HTML
comment, and it would show up in the HTML file after ```rake generate```
was called.  I wrote a small shell script call ```generate``` that calls ```rake generate``` and then invokes the perl script ```imageCaption.pl``` on every generated html file:

{% include_code octopress/generate lang:bash %} 

And, here's ```imageCaption.pl```.  It searches for the markup and
replaces it with the appropriate HTML.

{% include_code octopress/imageCaption.pl lang:perl %} 

In order to tie this all together, I had to define the css classes for
the various 'ai...' classes.  I added the following code to ```sass/custom/_styles.scss```:

{% include_code octopress/_styles.scss lang:scss %} 

Note that I added ```max-width:100%``` for all the divs and images -
this ensures that the images won't get cropped when the page is
displayed on a smaller, mobile display. 

You can see an example of these aligned images in my post on [how lenses work](/2010/01/23/how-camera-lenses-work/). 

### Web Server Optimizations

I host my site on an Apache 2 web server.  [As I had done with my taskforest website](/2010/04/10/google-now-considers-website-speed-in-its-ranking/#optimizing) ,
I decided to optimize the site and get a high score from 
[PageSpeed](http://code.google.com/speed/page-speed/).  I enabled
compression of html files, and turned on KeepAlive.  

I also had to change my site redirections.  Originally, I was
redirecting aijazansari.com to 
www.aijazansari.com.  However, I noticed
that my site was not being displayed correctly on Windows Internet
Explorer Version 8.  As [this page](https://github.com/imathis/octopress/issues/89) shows, 
it's probably due to
poorly-implemented restrictions to prevent cross-site scripting.  I
changed the redirections to be the other way around, and then the site
worked fine on IE8.  I've included the relevant part of my ```httpd.conf``` 
file below: 

{% include_code octopress/httpd.conf lang:apacheconf %}

### Excluding Myself From Google Analytics Reports

While I tweak this blog, I'll be accessing it very often.  I don't want
my accesses to influence the Google Analytics reports.  I followed the 
advice on [this page](http://www.instantfundas.com/2009/01/how-to-stop-google-analytics-from.html)
and set up Analytics to ignore the cookie that only I would have set. 

**Update 2011/12/20 - ** These instructions didn't work.  Read 
[my next post](/2011/12/20/excluding-yourself-from-google-analytics/) to see how I got it to work.

### Can't Forget The FavIcon

Finally, I overwrote the default ```favicon.png``` with my own version.
It was the fininshing touch to get the blog 'just right' (for now).

### Plans For The Future

The first thing I want to change about my blog is the theme.  I think
the default Octopress theme is very good, but I personally prefer the
more minimalistic themes.  I used to use [Basic Maths](http://basicmaths.subtraction.com/) on my WordPress
site.  I might have to learn some Ruby, and also learn about Liquid and
Jekyll, but I would like to make a theme that's somewhere between
[Minimal Mac](http://minimalmac.com/) and Basic Maths.  I'm also gonna
have to replace my Perl image alignment hack to a Liquid plugin soon.


title: Excluding Yourself From Google Analytics
date: 2011-12-20 17:56
Category: Computers
Tags: Octopress, Analytics

In [my last post](/2011/12/12/switching-to-octopress/) I wrote that I followed some instructions to 
exclude myself from Google Analytics' reports on my Octopress blog.  There was an error in the 
Javascript that was preventing the required cookie from being set.  Here's what I did 
that finally worked: 

<!-- more -->

The instructions that I found in Google's [support forum](http://support.google.com/googleanalytics/bin/answer.py?hl=en&answer=55481) 
correctly show how to set a filter to exclude any requests where the client has a custom cookie set. 
However, the javascript code that's supposed to generate the cookie gave me a 'variable not defined' error. 
[This page](http://www.google.com/support/forum/p/Google%20Analytics/thread?tid=251cc127a52875ef&hl=en) 
had the instructions that worked for me.  For completeness, here's the current version of the HTML file
I use to exclude myself from the reports:

{% include_code octopress/exclude.txt lang:html %} 

Essentially, I moved the line that sets the cookie from the ```body``` tag to line 11.


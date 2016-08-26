---
title: "Tag Clouds With Octopress"
date: 2012-01-07 06:00
comments: false
Category:
- Computers
tags:
- Octopress
- Tags
- Blogs
- Ruby
- Perl
- My Code
- GitHub
---

In this post I'll show you how I added tag clouds to my Octopress blog.  

<!-- more -->

Before I go any further I want to stress something: **While this is a robust
solution, it's not the optimal solution, and not a permanent solution.**  I 
don't know whether it's particularly elegant, either.  It's not ugly, but it isn't beautiful.  There
is [at least one](https://github.com/imathis/octopress/pull/282) project in the 
works to add tags to Octopress.  When that's pulled into the main Octopress 
repository, it will probably be the way tag clouds ought to be done.  Despite that
I came up with my own way to do it for the following reasons:

* I don't know Ruby yet.  I'm learning, but I don't feel comfortable
  incorporating so much code I don't understand.
* I don't want to re-invent the wheel in Ruby.  Ted Kulp, the author of the
  commit shown above, seems to have done all the heavy lifting.  I look forward
  to incorporating his changes once they're in Octopress proper.  My solution's
  written in Perl, and as far as I'm concerned, my solution is a short-term
  one.

Having said that, read on to see how I got the tag clouds that you see in this blog working.

There are three parts to this problem:

1. Displaying a list of tags applied to the current post at the bottom of each
   post.
2. Clicking through from a tag name in that list to a tag page that lists all
   posts with that tag.
3. Generating and displaying the tag cloud.

<h2>Displaying a list of tags</h2>

This was pretty easy to get right.  I modified ```source/_layouts/post.html``` to include a new file called ```tags.html``` ([View in GitHub](https://github.com/aijaz/octopress/commit/d72ad36b52d278f189260f80fb355c01e60542b8#diff-6)):

    :::diff
    ...
           {% include post/author.html %}
           {% include post/date.html %}{% if updated %}{{ updated }}{% else %}{{ time }}{% endif %}
           {% include post/categories.html %}
    +      {% include post/tags.html %}
         </p>
         {% unless page.sharing == false %}
           {% include post/sharing.html %}
    ...

I then created ```source/_includes/post/tags.html``` which is shown in it's entirety here: ([View in GitHub](https://github.com/aijaz/octopress/commit/d72ad36b52d278f189260f80fb355c01e60542b8#diff-5))

~~~~{.HTML}
<div id="atag_list">
    Tags: 
    <ul id="tags_ul">
{% for t in page.tags  %}
        <li><a href="/tags/{{t}}/">{{t}}</a></li>
{% endfor %}
    </ul>
</div>
~~~~

I chose to display tags as a list so that screen readers and other renderers
interpret this correctly as a list of entries, rather than a sentence where
each word is an anchor. Finally I added the appropriate CSS to display the tag
list properly in the browser.  

    :::css
    div#tag_list {
        font-size: 12pt;
    }
    
    #tags_ul { 
        display: inline;
    }
    
    #tags_ul li:last-child:after {
      content: "";
    }
    
    #tags_ul li:after {
      content: ", ";
    }
    
    #tags_ul li {
        display: inline; 
    }

<h2>Generating the tag files and tag cloud</h2>

This was the most involved step of all. I wrote a script called ```tagify.pl```
that generates the tag markdown files as well as a file containing the HTML
markup for the tag cloud.  I started off parsing the markdown files with a YAML
parser and gathering the tags from there.  But then I realized that for each
tag's page I would have had to know the URL of the posts that are marked with
that tag.  If I only have access to the markdown then I would have to duplicate
Octopress's code that determines a location for a post in the public directory
- the _/yyyy/mm/dd/modified-file-name.html_ logic.  

Rather than do that and tightly couple my hack with Octopress's code I decided
to parse the generated HTML instead.  Therefore, my script would have to be run
after ```rake generate``` is called.  *But!* My script has to generate tag
files and tag clouds that get pulled into asides in the sidebar!  That means
that ```rake generate``` has to be called after my script as well - a second
time.  Now do you believe me when I say that this is a temporary solution?  It
works, but it's not very efficient.  

But you know what?  I'm happy with it.  I could have waited until I was done
learning Ruby, and done learning the Liquid Template Manager, and done learning
Octopress's idioms and then started with this project.  I could have waited
until Ted Kulp's changes were pulled into the master Octopress branch.  But I
know what I want, and I know I can write decent code.  It took a few hours, but
I was able to get tag clouds done and move on.  I'm not emotionally attached to
this code and will gladly abandon it when something better comes along.   The
way I've designed it, it will be easy to pull it out - instead of running 

    rake generate
    ./tagify.pl
    rake generate

I'll just run

    rake generate

Since ```tagify.pl``` is rather long (307 lines with comments), I'll include it
in the Appendix at the bottom of this post, and just 
[link to it](/downloads/code/tags/tagify.pl) here.

What's important to remember is that ```tagify.pl``` does 3 things: 

* It creates a single file called ```source/_includes/custom/tag_cloud.html``` that looks like this 

    :::text
    <div id='tag_cloud'>
    <a href="/tags/Editors/" title="6 entries" class="tag_10">Editors</a>
    <a href="/tags/Firefox/" title="2 entries" class="tag_3">Firefox</a>
    </div>

The title is included for accessibility, and the classes ```tag_1``` 
through ```tag_10``` are used to display the tags in the appropriate size.

* For each tag it creates a file that lists all the posts tagged with that tag in reverse chronological order.  For the tag ```Editors``` it would create ```source/tags/Editors/index.markdown```

* It creates one file called ```source/tags/index.markdown``` that includes the ```tag_cloud.html``` file in the main article area.

<h2>Displaying the tag cloud</h2>

To display the tag cloud in the right sidebar I added a default aside in ```_config.yaml```:

    default_asides: [asides/recent_posts.html, asides/twitter.html, asides/tag_cloud.html]

I then created the file ```source/_includes/asides/tag_cloud.html```.  This
file includes the ```source/_includes/custom/tag_cloud.html``` file that was
generated by ```tagify.pl```above.

    :::html
    <section>
        <h1>Tags</h1>
        <div class="tag_cloud">
         {% include custom/tag_cloud.html %}
        </div>
    </section>

I then modified sass/custom/_styles.css to include the css for each of the 10 tag 'buckets': 

    :::css
    .tag_1 { 
        font-weight: 200; 
        font-size: 10pt;
    }
    .tag_2 { 
        font-weight: 200; 
        font-size: 12pt;
    }
    ...
    .tag_10 { 
        font-weight: 900; 
        font-size: 24pt;
    }

Finally, I added a line to ```source/_includes/custom/navigation.html``` to link to the main Tags page: ([View in GitHub](https://github.com/aijaz/octopress/commit/d72ad36b52d278f189260f80fb355c01e60542b8#diff-3))

    :::html
    ...
       <li><a href="{{ root_url }}/">Home</a></li>
       <li><a href="{{ root_url }}/about/">About Me</a></li>
       <li><a href="{{ root_url }}/categories/">Categories</a></li>
    +  <li><a href="{{ root_url }}/tags/">Tags</a></li>
       <li><a href="{{ root_url }}/blog/archives">Archives</a></li>
    ...


<h2>Summary</h2>

It bears mentioning that you don't always need to run ```tagify.pl```.  You
only need to run it if you've updated the tags on a post.  If you have changed
a tag, you must run ```rake generate``` before and after running
publishing ```tagify.pl```.  If you're just working on edits to a post before 
it, you don't need to run ```tagify.pl``` every time you want to view your post
on your local machihne . ```rake generate``` is enough. 

I'm glad to say that I was able to get tags to work with Octopress exactly the
way I wanted. It was pretty quick, too.  It took me longer to write this blog
post than to actually do the work.  If you like this post, please let me know
on Twitter, where I'm [@\_aijaz\_](https://twitter.com/#!/_aijaz_).  Thanks.


<h2>Appendix - tagify.pl</h2>

This is what ```tagify.pl``` looks like.  I describe the code in the comments within the file.

{% include_code tags/tagify.pl lang:perl tagify.pl %} 


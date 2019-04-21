title: How to Make a Pinboard Search Engine Shortcut
date: 2012-08-29 08:36
comments: false
Category: Computers
Tags: Pinboard, Chrome, Browsers, Productivity, Efficiency

<!-- ai l /images/pinboardSearch/hero.png /images/pinboardSearch/hero.png 340 139 Pinboard as a Search Engine -->

Now that I've been using Pinboard for a while, I find myself having to
search for one bookmark or another quite often.  I grew weary of going to
my Pinboard page, clicking on the search box and entering my query.
Here's how I streamlined it in Chrome.

<!-- more -->

<div style="clear: both"></div>

### What's Pinboard?

[Pinboard](http://pinboard.in) describes itself as a "fast, no-nonsense
bookmarking site."  I used [delicious](http://delicious.com) until it was
acquired by AVOS, and then switched to Pinboard.  With Pinboard you can
tag your bookmarks and use the site's search field to retrieve bookmarks
that match a certain tag.

I found myself using the search feature very often, so I decided to make
Pinboard's search field a search engine in Chrome, my current preferred
browser.  This is essentially the same thing I did with Firefox in
[this blog post from 2010](/2010/04/03/firefox-search-shortcut/index.html). 

### Adding the Search Engine to Chrome

As we did with Firefox, the first step is to right-click on the search
field.  From the pop-up menu that appears select "Add as Search
Engine...".

<!-- ai c /images/pinboardSearch/rightClick.png /images/pinboardSearch/rightClick.png 332 503 Step 1 - Right-click on the search field -->

### Choosing a Shortcut

When you select "Add as Search Engine..." from the pop-up menu, you'll see
a dialog box that prompts you for the name and keyword of the search.  In
this example I chose 'pi' as the keyword. I wanted something small that's
easy to type quickly.  Click "OK" and that's it.  You've just added a
search engine to Chrome.

<!-- ai c /images/pinboardSearch/rightClick.png /images/pinboardSearch/enterData.png 399 189 Step 2 - Enter the Shortcut -->

### Testing it out

To test it out, go to Chrome's unified search/address bar and type in 'pi'
followed by a space.  You'll see that the prompt changes to "Search
pinboard.in" because 'pi' was the keyword shortcut you chose and
"pinboard.in" was the name of the search engine.  Now you can enter any
tag name and hit Enter, and you'll be taken to those bookmarks of yours
that have that tag.

<!-- ai c /images/pinboardSearch/example.png /images/pinboardSearch/example.png 512 246 An Example Search -->

You may have noticed that this search engine only searches your
bookmarks. If you want to search all bookmarks, change the URL in the
dialog box when you add the search engine.  Look for where it says
```mine=Search+Mine``` and change that to ```all=Search+All```.  

To change an existing search engine, go to your your Chrome settings by
typing in ```chrome://chrome/settings/``` into the unified search/address
bar and then click on the button named "Manage search engines."  From
there you should be able modify the search engine or delete it
altogether. 

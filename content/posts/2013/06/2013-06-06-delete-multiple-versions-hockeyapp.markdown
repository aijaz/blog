title: "How to Delete Multiple Versions of an App in HockeyApp"
date: 2013-06-06 09:30
comments: false
Category: Computers
Tags: UNIX, bash, zsh, Shell, Productivity, HockeyApp, REST, WebServices

I recently needed to issue several dozen HTTP DELETE REST API calls of the
form http://www.example.com/blah/n where n was a sequential version
number.  In this post I'll show how to do this easily from the command
line.
<!-- more -->

<hr>

**Update** The [nice folks at HockeyApp](https://twitter.com/hockeyapp)
just pointed out that as far as HockeyApp is concerned, there is an API
for deleting multiple versions.  So while you don't need to use ```seq```
for deleting versions from HockeyApp, it's still a good tool to be aware
of.

<blockquote class="twitter-tweet"><p>@<a href="https://twitter.com/_aijaz_">_aijaz_</a> Script looks good, but are you aware of the Multiple Versions Delete documented here? <a href="http://t.co/QsQimlLgF8" title="http://support.hockeyapp.net/kb/api/api-delete-versions">support.hockeyapp.net/kb/api/api-del…</a></p>&mdash; HockeyApp (@hockeyapp) <a href="https://twitter.com/hockeyapp/status/342686984176807937">June 6, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<hr><p></p>

As I was showing someone how to deploy apps to beta testers, I tried to
upload a tiny demo app to my account at
[HockeyApp](http://www.hockeyapp.net). It failed because I was over my
storage limit.  I had to delete old versions of my apps from Hockey so
that I could continue using it without upgrading to the next higher tier
of service.

One of my apps had 60 versions that wanted to delete.  I definitely didn't
want to delete them manually, so I turned to the API docs.  Hockey's help page
[conveniently shows](http://support.hockeyapp.net/kb/api/api-delete-apps)
the ```curl``` command to delete a version:

    curl \
    -X DELETE \
    -H "X-HockeyAppToken: 4567abcd8901ef234567abcd8901ef23" \
    https://rink.hockeyapp.net/api/2/apps/1234567890abcdef1234567890abcdef
    
This is where the command line comes to the rescue.  I needed to wrap the
curl command in a loop that goes from 1 to 60.   To this I used the
[```seq``` command](http://ss64.com/bash/seq.html) that is available on
Mac OS and Linux:

    :::bash
    # Send a bunch of sequential HTTP DELETE requests
    $ TOKEN=4567abcd8901ef234567abcd8901ef23
    $ APPID=1234567890abcdef1234567890abcdef
    $ for version in `seq 60 1`
    do curl -w "$version: Result: %{http_code}\n" \
            -X DELETE \
            -H "X-HockeyAppToken: $TOKEN" \
            https://rink.hockeyapp.net/api/2/apps/$APPID/app_versions/$version
    done

This will execute the ```curl``` command for version 60 down to version 1
using the appropriate token and app ids.  I hope you find this as useful
as I did.

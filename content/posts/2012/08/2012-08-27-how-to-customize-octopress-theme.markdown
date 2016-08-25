---
title: "How to Customize your Octopress Theme"
date: 2012-08-27 01:18
comments: false
Category:
- Computers
tags:
- Octopress
- User Interface
---

<!-- ai l /images/theme/version0.png /images/theme/version0T.png 384 216 A Sample Octopress Site (click to enlarge) -->

As you've probably noticed I've modified my Octopress installation so the
color theme is light and minimalistic. Since some of you wanted to know,
here's how I did it.

<!-- more -->

<div style="clear: both"></div>

## Sass - Style With Attitude

Octopress comes with a very well organized hierarchy of style sheets.
These are not 'merely' CSS3 style sheets but rather Sass documents.
[Sass is an extension of CSS3](http://sass-lang.com/) that adds nested
rules, variables and a whole lot more.  If you haven't tried Sass yet,
give it a shot - you'll find that, as advertised, it makes CSS3 fun
again.

In an Octopress installation there is one file in particular,
sass/custom/_colors.css,  that is invoked after almost all the others.
This file is the one in which you are encouraged to make changes to your
site's color scheme.  It turns out that all the changes necessary to make
my site look the way it does can be made in that one file.

## The Changes

There are three sets of changes that I needed to make; I needed to change
the backgrounds, the header and footer, and the navigation bar.  I'll go
over each set here.  I won't explain the CSS, since I'll assume you know
how CSS works.

<!-- ai c /images/theme/version0.png /images/theme/version0s.png 512 288 The 'Before' Picture -->

The first thing to do was to change the background colors.  To do this, I
added the following lines to sass/custom/_colors.scss:

    // ////////////////////////////////////////
    // change the background colors
    //
    html {
      background: #fff !important;
    }
    body {
      > div {
        background: #fff !important;
        > div {
          background: #fff !important;
          }
      }
    }
    $main-bg: #ffffff !default;
    $page-bg: #ffffff !default;

These lines set all the backgrounds to white and override earlier
directives that set some of the backgrounds to a lightly speckled
```noise.png``` file. They use some of the constructs made possible with
Sass.  To find out exactly what they do, please read the Sass documentation.

This is how the site looked after this one change: 

<!-- ai c /images/theme/v01_bg.png /images/theme/v01_bgs.png 512 288 Made the page backgrounds white -->

Then I added the following code to change the background of the headers
(since that needed a more specific rule):

    // ////////////////////////////////////////
    // change the header colors
    //
    $header-bg: #fff;
    $title-color: #000000 !default;
    $text-color: #333 !default;
    $text-color-light: #777 !default;
    $subtitle-color: darken($header-bg, 58);

This change made the site look like this: 

<!-- ai c /images/theme/v02_header.png /images/theme/v02_headers.png 512 288 Made the header backgrounds white -->

Finally, I needed to add the following code to change the navigation bar
and the footer: 

    // ////////////////////////////////////////
    // change the nav bar
    //
    $nav-bg: #fff;
    $nav-bg-front: #fff;
    $nav-bg-back: #fff;
    $nav-color: darken($nav-bg, 78) !default;
    $nav-color-hover: darken($nav-color, 25) !default;
    $nav-border: darken($nav-bg, 50) !default;
    $nav-border-top: darken($nav-bg, 33) !default;
    $nav-border-bottom: darken($nav-bg, 33) !default;
    $nav-border-left: darken($nav-bg, 11) !default;
    $nav-border-right: lighten($nav-bg, 7) !default;
    
    
    // ////////////////////////////////////////
    // change the footer
    //
    $footer-color: #888 !default;
    $footer-bg: #fff !default;
    $footer-bg-front: #fff !default;
    $footer-bg-back: #fff !default;
    $footer-color: darken($footer-bg, 38) !default;
    $footer-color-hover: darken($footer-color, 10) !default;
    $footer-border-top: lighten($footer-bg, 15) !default;
    $footer-border-bottom: darken($footer-bg, 15) !default;
    $footer-link-color: darken($footer-bg, 38) !default;
    $footer-link-color-hover: darken($footer-color, 25) !default;
    $page-border-bottom: darken($footer-bg, 5) !default;

This made the site look like this:

<!-- ai c /images/theme/v03_nav.png /images/theme/v03_nav.png 512 288 The final version with the nav bar and footer backgrounds white -->

And that was it! I hope you found this helpful.  If you play around with
the Sass files, you'll find that it's very easy to make really complex
changes to your Octopress theme.


### But wait! There's more

Oh, one more thing: I also wanted to use fonts from
[TypeKit](http://typekit.com).  I signed up with TypeKit and used
*Chaparral Pro* for the body text and *Minerva Modern* for the headers.  I
had to change sass/custom/\_fonts.scss and sass/custom/\_styles.scss as
instructed by the TypeKit documentation.

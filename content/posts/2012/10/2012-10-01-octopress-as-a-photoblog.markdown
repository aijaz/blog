---
title: "Using Octopress as a Photo Blog"
date: 2012-10-01 22:00
comments: false
Category:
- Computers
tags:
- Octopress
- Photography
description: "In this post I illustrate how I modified the default Octopress theme and added a type of layout that highlights a single photograph."
---

As an amateur photographer I like displaying my photos on my blog, especially when there are particularly interesting stories behind them. In this post I'll show you how to modify the default Octopress theme and add a type of layout that highlights a single photograph.  You can see an example of this in [this sample blog](http://testphoto.aijazansari.com).  
<!-- more -->
The first post in this sample blog is a "regular" post, and the second is a photo post - a photo of Cloud Gate, also known as "The Bean."


## Requirements

Before starting, lets look at the key requirements for my new layout: 

1. In this new layout the photograph should be the primary focus of the page.
2. The blog's title and subtitle above the navigation bar should be diminished, to allow for more vertical real estate for the photograph.
3. All the details of the photograph should be specified in the YAML preamble of the post.  The contents should only be notes.
4. Octopress should automatically display a thumbnail of the photograph in the Index view.
5. The photographs should be optimized for Retina displays, but still look good on normal displays
6. The header should not be displayed at the top of the page.  Instead, it should be displayed underneath the photograph.



## The New YAML Tags

In this solution the YAML preamble dictates how the page is displayed.  A typical photo post in its entirety is shown below, along with comments.  Most importantly, instead of ```layout: post``` what you should have is ```layout: photo```.

The next three tags are required.  They specify the URI of the photograph as well as its dimensions. 

The rest of  tags are also supported, and are optional.  If you include them, the respective value will be displayed on the web page. All of these values are treated as strings.  In the file below, a sample value is shown, and a descriptive comment appears above the tag.

    :::bash
    ---
    title: "The Title of the Post"
    date: 2012-09-02 11:30
    comments: false
    Category:
    - Photos
    
    tags: 
    - Tag 1
    - Tag 2
    
    #########################################
    ##
    ## start of required tags
    
    # The URI of of the photo to be displayed in this post
    image: /images/photos/coolPhoto.jpg 
    
    photoWidth: 768       # width in pixels
    photoHeight: 511      # height in pixels
    
    ## end of required tags
    ##
    #########################################
    
    # The URI to a thumbnail image. This thumbnail
    # will be displayed on the index page.
    thumbnail: /images/photos/coolPhotoTn.jpg
    
    thumbnailWidth: 384   # width in pixels
    thumbnailHeight: 256  # height in pixels
    
    iso: 400              # ISO
    
    aperture: 4.8         # The aperture value 
    
    shutterSpeed: 0.4     # Shutter speed in seconds
    
    focalLength: 24.0 mm  # Focal length of the lens
    
    scaleFactor: 1.0      # Scale Factor to 35mm
    
    flash: No Flash       # Was the flash used here?
    
    expComp: N/A          # Exposure Compensation
    
    camera: Nikon D700    # Camera Model
    
    lens: AF-S VR Zoom-Nikkor 24-120mm f/3.5-5.6G IF-ED  # Lens 
    
    creator: Your Name    # Photographer Name
    
    # Date and Time the photograph was taken
    dateTaken: 2012/03/29 16:21:19
    
    # Copyright information
    copyright: Copyright 2012 Your Name
    
    # License information - This may be HTML
    license: <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-nd/3.0/80x15.png" /></a>    
    
    # The URI to an image of the photo's histogram
    histogram: /images/photos/coolPhotoHist.jpg
    
    histogramWidth: 128   # width in pixels
    histogramHeight: 50   # height in pixels
    ---
    
    This is what's called the content.  This text will 
    be displayed underneath the photo in the photo post.

These are just the tags that are supported by the system described in this blog post.  You can always add more tags and use them in the ```source/_includes/photoFile.html``` file that you'll see in a little bit.  Later in this post I'll also show you how to extract this information from your photograph's [EXIF data](http://digital-photography-school.com/using-exif-data).

## Layouts and Includes
### The Layout

The first step is to create a new layout file.  Since we're using ```layout: photo``` in the YAML preamble, we need to create a file called ```source/_layouts/photo.html```.  This layout file is almost identical to ```source/_layouts/post.html```, so I'll just show you the diffs: 

{% include_code photoBlog/photo.diff lang:diff photo.html %}

Here are the changes: 

- I've set the ```sidebar``` YAML tag to ```collapse```.  This instructs octopress to collapse the sidebar and display it instead at the bottom. 
- I've set the ```no_header``` tag to ```true``` so that the post header is not displayed.
- I've set a new YAML tag: ```header: condensed```.  We'll see how this is used a little later.
- Instead of including ```article.html```, I'm including ```photoFile.html``` (found at ```source/_includes/photoFile.html```).

Now that we've told Octopress that the photo layout should include ```photoFile.html```, it's time to have a look at that file. Since it's so similar to ```source/_includes/article.html``` (before we change that file), I'll just show you the differences between the two files: 

{% include_code photoBlog/photoFile.diff lang:diff photoFile.diff %}

As you can see, what we've done is replace line 4 with lines 5 through 30.  Instead of merely displaying the ```content```, we're also displaying a table with all the EXIF data that we provided in the YAML preamble.  We wrap each table row in an if/endif block, so that we don't include blank rows if any of the EXIF data is missing. 

If you want to support more data than you see in this table, simply modify this table, and then make sure to include that data in the YAML preamble.

### Displaying Thumbnails in the Index

In order to display the thumbnail of the image in the index view I changed ```source/_includes/article.html```: 

{% include_code photoBlog/article.diff lang:diff article.diff %}

What this says is that if Octopress is displaying the index and the current post's YAML has a ```thumbnail``` tag defined then display the thumbnail image in its own div and make the thumbnail a link to the actual post. 

### Condensing the Header

To get the condensed version of the header I changed ```source/_layouts/default.html```: 

{% include_code photoBlog/default.diff lang:diff default.diff %}

In the first set of changes (lines 5-10), if the page has a YAML tag of ```header``` whose value is ```condensed```, then instead of including ```header.html```, we'll include ```custom/headerCondensed.html```, and make the header be of the class ```condensed```.  In the second set of changes (lines 12-15) we assign a class of ```photo``` to the ```main``` and ```content``` divs if the post's YAML has an ```image``` -- in other words, if the post is a photo layout post.  This is merely so that we can apply different styles to the photo pages.

The ```custom/headerCondensed.html``` file is shown below:

{% include_code photoBlog/headerCondensed.txt lang:html custom/headerCondensed.html %}


## CSS Changes

All of the changes to CSS are in ```sass/custom/_styles.scss```: 

{% include_code photoBlog/styles.scss lang:css _styles.scss %}


## Supporting Retina Displays

It is easy to add support for retina displays using [retina.js](http://retinajs.com).  I added ```retina.js``` to ```source/javascripts``` and modified ```source/_includes/custom/after_footer.html``` as follows: 

{% include_code photoBlog/after_footer.diff lang:diff after_footer.diff %}

I chose to add ```retina.js``` to photo pages (pages that have an ```image``` YAML tag) and to index pages (for the thumbnails).  If you want, you can chose to support retina displays all the time.  In order to get this to work, I also had to add *@2x* versions of the main photo, the thumbnail as well as the histogram image. You can find more detailed instructions on the [retina.js website](http://retinajs.com/).

## Automation

There are two helper scripts that I use to help me with my photo posts.  I'm including them here with the hope that you might benefit from them.  You will need to modify them for your own purposes. These scripts are available on github at [https://github.com/aijaz/photoBlog](https://github.com/aijaz/photoBlog). 

The first script, ```convertPhoto.pl```,  converts a double-sized retina image to the non-retina version.  It also generates the thumbnail and histogram images and invokes the second script.  

The second script, ```generatePhotoPost.pl```, extracts the EXIF information from the image and generates the YAML preamble and creates the post file.  You can run this script even if the post file already exists - it will overwrite the preamble, but will preserve any content that you had already typed in earlier.

## Future Enhancements

This is a simple solution that displays one image per blog post.  The main enhancement I would like to make in the future is the ability to display multiple photos in a single post.  This would also allow for the addition of a series of photographs to a 'normal' post.  

## Summary

Although this post shows you how to make an Octopress-powered photoblog, it's really about the flexibility of the YAML preamble in general and the ```layout``` tag in particular.  With the proper inclusion of supporting files, layouts can be used to create wildly differing types of posts within a single blog.  Finally, please keep in mind that we *added* a new layout, and did not change the ```post```layout.  This means that even if you make the changes described in this post, you won't lose any of the functionality of Octopress.

## References

1. [Building Static Sites with Jekyll](http://net.tutsplus.com/tutorials/other/building-static-sites-with-jekyll/)
2. [EXIF Wikipedia Page](http://en.wikipedia.org/wiki/Exchangeable_image_file_format)
3. [EXIF data](http://digital-photography-school.com/using-exif-data)
4. [Image::ExifTool at CPAN](http://search.cpan.org/dist/Image-ExifTool/)
5. [ImageMagick](http://www.imagemagick.org/)
6. [Retina.js](http://retinajs.com/)
7. [A sample Octopress photoBlog](http://testphoto.aijazansari.com/)
8. [A photo page on this blog](http://aijazansari.com/2012/08/31/horseshoe-bend/)
9. [The photoBlog script repository](https://github.com/aijaz/photoBlog)

---
title: "Viewing OmniGraffle Files in XCode"
date: 2015-02-17 20:12
comments: false
Category:
- Computers
tags:
- XCode
- OmniGraffle
- Automator
- Coding
- Design
- AppleScript
- Services
- Hazel
- Diagrams
- iOS
description: In this post I show you how to add OmniGraffle files into an XCode project and have the generated PDFs update automatically.
---

When I work on complex iOS apps, I like to diagram the complex relationships between classes and subsystems in [OmniGraffle](https://www.omnigroup.com/omnigraffle). In this post I'll show you how to add OmniGraffle files to XCode, view them from within XCode and keep them updated automatically. 

<!-- more -->

<!-- ai c /images/2015/02/omniGraffle/omniGraffleDiagram.png /images/2015/02/omniGraffle/omniGraffleDiagram.png 724 506 A sample OmniGraffle diagram -->


<div style="clear: both"></div>

## The Problem

I wanted to add an OmniGraffle file to my XCode project and have XCode display it when I click on it. However when I did that, instead of showing me what QuickLook would show me in the Finder, I saw the raw XML contents of the OmniGraffle file. I've filed a [bug report](http://www.openradar.me/19849334) with Apple, asking them to fix this. I wanted to be able to view the diagram, and also launch OmniGraffle from within XCode.  

## The Solution

Here's the summary of what I did: I created a service that takes no input and only runs within XCode. This service will launch OmniGraffle and open the file that's being displayed (as XML) in the current XCode tab. The second thing I did is create a rule in [Hazel](http://www.noodlesoft.com/hazel.php) that monitors the directory in which I save OmniGraffle files. Whenever a file is created or saved, this rule will run a script that converts the OmniGraffle file into a PDF document.

That's the solution in a nutshell. To see how I did it, keep reading.

## Opening in an external editor

After a little Googling I found an [elegant AppleScript](http://devmake.com/xcode-open-file-in-current-tab-in-external-editor-macvim/) written by [Milan Krystek](https://twitter.com/devmake). This script opens the current file with an external editor. I changed the code to use OmniGraffle Professional instead of MacVim. For completeness I'm including the code that I use over here:

{% codeblock lang:applescript AppleScript to open the current file in an external editor %}
on run {input, parameters}
    -- via http://devmake.com/xcode-open-file-in-current-tab-in-external-editor-macvim/
    
    set current_document_path to ""
 
    tell application "Xcode"
        set last_word_in_main_window to (word -1 of (get name of window 1))
        if (last_word_in_main_window is "Edited") then
            display notification "Please save the current document and try again"
            -- eventually we could automatically save the document when this becomes annoying
        else
            set current_document to document 1 whose name ends with last_word_in_main_window
            set current_document_path to path of current_document
        end if
    end tell
 
    tell application "OmniGraffle Professional"
        if (current_document_path is not "") then
            activate
            open current_document_path
        end if
    end tell
 
    return input
    
end run
{% endcodeblock %}

To install this code as a service I first started up Automator. I created a new service and set it up to receive no input and run in XCode as shown below.

<!-- ai c /images/2015/02/omniGraffle/newService.png /images/2015/02/omniGraffle/newService.png 500 316 Creating a new service -->

I then added a 'Run AppleScript' action to the workflow by dragging the entry from the library to the right. In the text entry area that appeared I added the AppleScript shown above:

<!-- ai c /images/2015/02/omniGraffle/runApplescript.png /images/2015/02/omniGraffle/runApplescript.png 500 316 Adding a 'Run AppleScript' action -->

Then I saved the service as 'OpenInOmniGrafflePro'.  The last bit was to bind a keyboard shortcut to this new service. To do this I went to the Keyboard System Preferences Pane, selected the 'Shortcuts' tab, scrolled down to 'Services' and assigned a shortcut to my newly-created service, as shown below. 

<!-- ai c /images/2015/02/omniGraffle/keyboardShortcut.png /images/2015/02/omniGraffle/keyboardShortcut.png 780 693 Adding a keyboard shortcut -->

## Viewing OmniGraffle files from within XCode

Now that I had a way to launch OmniGraffle files from within XCode, I wanted a way to display the diagrams within XCode's editor pane. I realized that if I exported the OmniGraffle file as a PDF document, I could view the PDF from within XCode. I didn't mind adding both the original OmniGraffle document as well as the PDF file to the project. What I **didn't** want to do was to have to remember to export the file to PDF every time I updated the OmniGraffle file.

## Keeping the PDF files in sync

In order to keep the PDF files in sync with the OmniGraffle document I created a rule in [Hazel](http://www.noodlesoft.com/hazel.php) to monitor the directory into which I'll save the OmniGraffle files. I set up the rule to match on all files whose extensions were ```.graffle``` and had been saved since the last time the rule matched. 

<!-- ai c /images/2015/02/omniGraffle/hazel.png /images/2015/02/omniGraffle/hazel.png 780 622 The Hazel rule -->

When this rule matches a file it calls ```graffle.sh``` on that file. This is a very useful bash script that I [found on GitHub](https://github.com/dcreager/graffle-export). I had to modify the bash file to accept a single command line argument. You can find the changes I made [here](https://github.com/aijaz/graffle-export/commit/94602863cf1f931f176e6be05dddd8c8bf89b9dc#diff-8420037d70f59fe3e96bf764e6ffc2bc), or you can just clone [my fork of this project](https://github.com/aijaz/graffle-export). 

With this rule in place Hazel now automatically generates a PDF file of the first canvas of any new or updated OmniGraffle file in the specific directory. This keeps the PDF files in sync with the OmniGraffle files.

## Conclusion

This is more than just an exercise in inter-app communication for me. As I work on increasingly complex apps I want to document the relationships between classes and subsystems for my future self as well as for other developers who may join the team and have to mantain my code. I have found that OmniGraffle is the best way to diagram these relationships, but if the diagrams are not kept current, they lose their value very quickly. While there is no way to continuously generate OmniGraffle diagrams with the desired level of complexity automatically, the hacks I've shown here at least make it easier to add OmniGraffle files to your XCode project and keep them up to date. 

I hope you find this as useful as I did.



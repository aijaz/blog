title: Moving to Pelican
date: 2016-08-28 00:30
Category: Computers
Tags: Octopress, Pelican, Ruby, Python

Several times in the past few months I have tried to add a post to this blog. But I couldn't because of some obscure Ruby error whenever I tried to generate the blog using Octopress. There was so much friction in the simple act of adding a new post, that I finally decided enough was enough and moved the blog to Pelican.

<!-- more -->

There are several advantages to Pelican:

- It's written in python, as are its plug-ins. This is good for me, because I have recently switched over to using the python-based Flask framework for my backend web development needs. More on that in a future post. I can read Pelican and plug-in sources and understand how things work. 
- I am also very familiar with the `venv` based python setup. Setting up and maintaining a python virtual environment is much easier for me than doing that for a ruby environment. 
- It uses the Jinja2 templating engine, which is the same engine that Flask uses. Working on templates for my personal blog has the side effect of making me better with templates on my other websites. 

There are many posts out there describing how to work with Pelican, and also how to move from Octopress to Pelican, so I won't bother adding yet another one to that list. I will mention, though, that with the [md-metayaml][] plug-in it was very easy to port my YAML-based source files to Pelican. 

The only difficult part was customizing the pelican-bootstrap theme to make it look like my customized Octopress theme. While it's not an exact copy, the final product is close enough. I'm sure I'll be tweaking it over time. 

Well, there we have it. I've moved to Pelican, and so far I've been very pleased with it. I hope the reduced friction will encourage me to write more posts. We'll see.

Until later...

[md-metayaml]: https://github.com/joachimneu/pelican-md-metayaml

#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Aijaz A. Ansari'
SITENAME = 'The Joy Of Hack'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'America/Chicago'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('TaskForest', 'http://taskforest.com/'),)

# Social widget
SOCIAL = (('Twitter', 'https://twitter.com/_aijaz_'),
          ('Instagram', 'https://instagram.com/aijaz_ansari'),)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

THEME = '../pelican-bootstrap3'


# Standard Pelican Settings
# 
DISPLAY_PAGES_ON_MENU = False
DISPLAY_CATEGORIES_ON_MENU = False
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'
ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'
SUMMARY_MAX_LENGTH = None
STATIC_PATHS = ['images', 'wp', 'static']
PLUGIN_PATHS = ['../pelican-plugins']
PLUGINS = ['summary', 
           'md-metayaml', 
           'tag_cloud', 
           'category_order',
           'liquid_tags.img', 
           'liquid_tags.video',
           'liquid_tags.youtube', 
           'liquid_tags.vimeo',
           'liquid_tags.include_code']
MENUITEMS = [
    ('About Me', '/about'),
    ('Categories', '/categories'),
    ('Tags', '/tags'),
    ]



# URL Settings

ARCHIVES_URL = 'archives/index.html'
ARCHIVES_SAVE_AS = 'archives/index.html'

CATEGORIES_URL = 'categories/index.html'
CATEGORIES_SAVE_AS = 'categories/index.html'

TAGS_URL = 'tags/index.html'
TAGS_SAVE_AS = 'tags/index.html'




# via http://jhshi.me/2015/10/11/migrating-from-octopress-to-pelican/
FILENAME_METADATA = '(?P<date>\d{4}-\d{2}-\d{2})-(?P<slug>.*)'



# Settings specific to pelican-bootstrap3
# 
BOOTSTRAP_THEME = 'readable'
SHOW_ARTICLE_CATEGORY = True
SHOW_DATE_MODIFIED = True
PYGMENTS_STYLE = 'vs'
CUSTOM_CSS = 'static/custom.css'
DISPLAY_RECENT_POSTS_ON_SIDEBAR = True
TWITTER_USERNAME = '_aijaz_'
TWITTER_WIDGET_ID = '567866007532752896'
DISPLAY_TAGS_ON_SIDEBAR = True

# Plugins

## summary
SUMMARY_END_MARKER = '<!-- more -->'

## category_order
# CATEGORIES_ORDER_BY = 'size-rev'
# TAGS_ORDER_BY = 'size-rev'

# tags
TAG_CLOUD_STEPS = 5
TAG_CLOUD_MAX_ITEMS = 100
TAG_CLOUD_SORTING = 'size-rev'

# for liquid
CODE_DIR = 'static/downloads/code'

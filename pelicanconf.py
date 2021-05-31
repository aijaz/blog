#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Aijaz Ansari'
SITENAME = 'The Joy of Hack'
SITEURL = ''
CDNURL = ''
THEME = './minimal-aaa'

JINJA_ENVIRONMENT = {"extensions": ["jinja2.ext.i18n"]}
# PLUGINS = ["i18n_subsites", "gzip_cacheSDFSDSF"]
# PLUGIN_PATHS = ["../pelican-plugins"]

PATH = 'content'

TIMEZONE = 'America/Denver'

DEFAULT_LANG = 'en'


# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = ()

# Social widget
SOCIAL = ()

DEFAULT_PAGINATION = 500
# DISQUS_SITENAME = "masjiddefense"

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

DISPLAY_PAGES_ON_MENU = False
DISPLAY_CATEGORIES_ON_MENU = False
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'
ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'
SUMMARY_MAX_LENGTH = None
STATIC_PATHS = ['images', 'wp', 'static', 'zf',]
PLUGIN_PATHS = ['../pelican-plugins']
PLUGINS = ['summary'
           # 'md-metayaml',
           # 'category_order',
           # , 'liquid_tags.img'
           # , 'liquid_tags.video'
           # , 'liquid_tags.youtube'
           # , 'liquid_tags.vimeo'
           # , 'liquid_tags.include_code'
           ]
#           'tag_cloud', 
MENUITEMS = [
    ('Blog', '/'),
    ]

# via https://github.com/getpelican/pelican/issues/1157
# skip zf html files
# These are the only html files around
READERS = {'html': None}


# URL Settings

ARCHIVES_URL = 'archives/index.html'
ARCHIVES_SAVE_AS = 'archives/index.html'

CATEGORIES_URL = 'categories/index.html'
CATEGORIES_SAVE_AS = 'categories/index.html'

TAGS_URL = 'tags/index.html'
TAGS_SAVE_AS = 'tags/index.html'

PAGE_SAVE_AS = '{slug}/index.html'

# via http://jhshi.me/2015/10/11/migrating-from-octopress-to-pelican/
FILENAME_METADATA = '(?P<date>\d{4}-\d{2}-\d{2})-(?P<slug>.*)'

TYPOGRIFY = True

# ARTICLE_ORDER_BY = 'sortorder'
# PAGE_ORDER_BY = 'sortorder'

# Settings specific to pelican-bootstrap3
# 
BOOTSTRAP_THEME = 'readable'
SHOW_ARTICLE_CATEGORY = True
SHOW_DATE_MODIFIED = True
PYGMENTS_STYLE = 'default'
CUSTOM_CSS = 'static/custom.css'

# Plugins

# summary
SUMMARY_END_MARKER = '<!-- more -->'
# SUMMARY_MAX_LENGTH = 20

# category_order
# CATEGORIES_ORDER_BY = 'size-rev'
# TAGS_ORDER_BY = 'size-rev'
CODE_DIR = 'static/downloads/code'


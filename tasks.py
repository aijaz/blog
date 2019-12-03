# -*- coding: utf-8 -*-

import os
import shutil
import sys
import datetime

from invoke import task
from invoke.util import cd
from pelican.server import ComplexHTTPRequestHandler, RootedHTTPServer

CONFIG = {
    # Local path configuration (can be absolute or relative to tasks.py)
    'deploy_path': 'output',
    # Remote server configuration
    'production': 'root@aijaz.net:22',
    'dest_path': '/home/aijaz/blog',
    'port': 8000,
}

@task
def clean(c):
    """Remove generated files"""
    if os.path.isdir(CONFIG['deploy_path']):
        shutil.rmtree(CONFIG['deploy_path'])
        os.makedirs(CONFIG['deploy_path'])

@task
def build(c):
    """Build local version of site"""
    c.run('pelican -s pelicanconf.py')

@task
def rebuild(c):
    """`build` with the delete switch"""
    c.run('pelican -d -s pelicanconf.py')

@task
def regenerate(c):
    """Automatically regenerate site upon file modification"""
    c.run('pelican -r -s pelicanconf.py')

@task
def serve(c):
    """Serve site at http://localhost:8000/"""

    class AddressReuseTCPServer(RootedHTTPServer):
        allow_reuse_address = True

    server = AddressReuseTCPServer(
        CONFIG['deploy_path'],
        ('', CONFIG['port']),
        ComplexHTTPRequestHandler)

    sys.stderr.write('Serving on port {port} ...\n'.format(**CONFIG))
    server.serve_forever()

@task
def reserve(c):
    """`build`, then `serve`"""
    build(c)
    serve(c)

@task
def preview(c):
    """Build production version of site"""
    c.run('pelican -s publishconf.py')


@task
def publish(c):
    """Publish to production via rsync"""
    c.run('pelican -s publishconf.py')
    c.run('yuicompressor output/static/custom.css >! /tmp/1')
    c.run('/bin/cp /tmp/1 output/static/custom.css')
    c.run('gzip -c output/static/custom.css >! output/static/custom.css.gz')
    c.run(
        'rsync --delete --exclude ".DS_Store" -pthrvz -c '
        '{} root@{production}:{dest_path}'.format(
            CONFIG['deploy_path'].rstrip('/') + '/',
            **CONFIG))


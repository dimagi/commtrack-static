from fabric.api import *
from fabric.contrib import console
from fabric import utils

env.code_repo = 'git@github.com:dimagi/commtrack-static.git'

def _join(*args):
    """
    We're deploying on Linux, so hard-code that path separator here.
    """
    return '/'.join(args)

def production():
    """ use production environment on remote host"""
    env.root = root = '/opt/commtrack-static'
    env.site_root   = _join(root, 'site')
    env.user = 'cchq'
    env.hosts = [
      'hqproxy0.internal.commcarehq.org',
      'hqproxy3.internal.commcarehq.org',
    ]
    env.environment = 'production'

def deploy():
    """ deploy code to remote host by checking out the latest via git """
    require('root', provided_by=('production'))
    if env.environment == 'production':
        if not console.confirm('Are you sure you want to deploy from github to production?', default=False):
            utils.abort('Production deployment aborted.')

    with cd(env.root):
        run('git pull origin master')
        run('git submodule update --init --recursive')

    with cd(env.site_root):
      run('nanoc compile')

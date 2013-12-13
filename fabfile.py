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
    env.sudo_user = 'cchq'
    env.hosts = ['hqproxy0.internal.commcarehq.org', 'hqproxy2.internal.commcarehq.org']
    env.environment = 'production'
    env.user = prompt("Username: ", default=env.user)

def deploy():
    """ deploy code to remote host by checking out the latest via git """
    require('root', provided_by=('production'))
    if env.environment == 'production':
        if not console.confirm('Are you sure you want to deploy from github to production?', default=False):
            utils.abort('Production deployment aborted.')

    with cd(env.root):
        sudo('git pull origin master', user=env.sudo_user)
        sudo('git submodule update --init --recursive', user=env.sudo_user)

    with cd(env.site_root):
    	sudo('rm -r output', user=env.sudo_user)
    	sudo('rm -r tmp', user=env.sudo_user)
    	sudo('nanoc compile', user=env.sudo_user)

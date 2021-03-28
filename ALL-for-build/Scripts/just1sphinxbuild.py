# /usr/bin/env python2
# coding: utf-8

from __future__ import print_function

import os
import shlex
import sys
from os.path import exists as ospe, join as ospj
from subprocess import call

cmd_fname = 'cmd.txt'
cwd = os.getcwd()
stderr_fname = 'stderr.bytes.txt'
stdout_fname = 'stdout.bytes.txt'
warnings_fname = 'warnings.txt'
logdir = '/RESULT/sphinx-build'

cmd_fpath = ospj(logdir, cmd_fname)
stdout_fpath = ospj(logdir, stdout_fname)
stderr_fpath = ospj(logdir, stderr_fname)
warnings_fpath = ospj(logdir, warnings_fname)

makehtml_cmd = (
    ' /ALL/venv/.venv/bin/sphinx-build'
    ' -v -v -v -b html'
    ' -c /ALL/Makedir'
    ' -j auto'
    ' -T -q '
    ' -w /RESULT/sphinx-build/warnings.txt'
    ' -d /RESULT/Cache'
    ' /PROJECT/Documentation'
    ' /RESULT/Result/project/0.0.0/'
).strip()

dirs_to_create = [
    '/RESULT',
    '/RESULT/Cache',
    '/RESULT/Result/project/0.0.0',
    logdir,
    ]


def makehtml():
    for adir in dirs_to_create:
        if not ospe(adir):
            os.makedirs(adir)
    cmdlist = shlex.split(makehtml_cmd)
    with open(cmd_fpath, 'w') as f2:
        f2.write(' \\\n'.join(cmdlist))
        f2.write('\n')
    with open(stdout_fpath, 'wb') as fd_stdout, open(stderr_fpath, 'wb') as fd_stderr:
        exitcode = call(cmdlist, stdout=fd_stdout, stderr=fd_stderr, shell=False, cwd=cwd)
    return exitcode


if __name__ == '__main__':
    exitcode = makehtml()
    sys.exit(exitcode)

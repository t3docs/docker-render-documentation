## /usr/bin/env python2
# coding: utf-8

from __future__ import print_function

import codecs
import os
import shlex
import sys
import threading
import time
import urlparse
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
from SocketServer import ThreadingMixIn
from os.path import exists as ospe, join as ospj
from subprocess import call

GD = global_data = dict(xeq_name_cnt=0, request_counter=0)
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

files_to_empty_at_start = [cmd_fpath, stderr_fpath, stdout_fpath]
dirs_to_create = ['/RESULT', '/RESULT/Cache', logdir, '/RESULT/Result/project/0.0.0']


def _quote_html(html):
    return html.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def prelines_of_file(fpath):
    prelines = []
    atext = "Showing file: '%s'" % fpath
    if ospe(fpath):
        prelines.append(_quote_html(atext + ' - and yes, it does exist.'))
        prelines.append('')
        prelines.append(_quote_html('=========================================='))
        prelines.append(_quote_html(fpath.split('/')[-1]))
        prelines.append(_quote_html('=============== File START ==============='))
        with codecs.open(fpath, 'r', 'utf-8', 'replace') as f1:
            for aline in f1:
                prelines.append(_quote_html(aline.rstrip()))
        prelines.append(_quote_html('=============== File E N D ==============='))
    else:
        prelines.append(_quote_html(atext + ' - but no, it does not exist.'))
    return prelines


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


class GetHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        GD['request_counter'] += 1
        msglines = []
        prelines = []
        msglines.append('request: %s' % GD['request_counter'])
        parsed_path = urlparse.urlparse(self.path)
        msglines.append('%s' % parsed_path.path)
        http_response_code = 200
        if parsed_path.path == '/makehtml_no_cache':
            exitcode = call(shlex.split('rm -rf /RESULT/Result /RESULT/Cache ' + logdir))
            if exitcode:
                http_response_code = 503
                server.shutdown()
                sys.exit(1)
            atime = time.time()
            exitcode = makehtml()
            btime = time.time()
            duration = '%3.3f' % round(btime - atime, 3)
            if exitcode:
                # Service Unavailable
                http_response_code = 503
                msglines.append('%s, %s, exitcode: %s, took: %s seconds' %
                    (http_response_code, 'failed', exitcode, duration))
            else:
                msglines.append('%s, %s, exitcode: %s, took: %s seconds' %
                    (http_response_code, 'succeeded', exitcode, duration))
            prelines = prelines_of_file(warnings_fpath)

        elif parsed_path.path == '/makehtml':
            for afile in files_to_empty_at_start:
                if ospe(afile):
                    with open(afile, 'wb') as f2:
                        pass
            atime = time.time()
            exitcode = makehtml()
            btime = time.time()
            duration = '%3.3f' % round(btime - atime, 3)
            if exitcode:
                http_response_code = 503
                msglines.append('%s, %s, exitcode: %s, took: %s seconds' %
                    (http_response_code, 'failed', exitcode, duration))
            else:
                msglines.append('%s, %s, exitcode: %s, took: %s seconds' %
                    (http_response_code, 'succeeded', exitcode, duration))
            prelines = prelines_of_file(warnings_fpath)

        elif parsed_path.path == '/show_cmd':
            prelines = prelines_of_file(cmd_fpath)

        elif parsed_path.path == '/show_stdout':
            prelines = prelines_of_file(stdout_fpath)

        elif parsed_path.path == '/show_stderr':
            prelines = prelines_of_file(stderr_fpath)

        elif parsed_path.path == '/show_warnings':
            prelines = prelines_of_file(warnings_fpath)

        elif parsed_path.path == '/shutdown':
            server.shutdown()

        else:
            http_response_code = 501
            msglines.append('%s, %s' %
                    (http_response_code, 'unknown action, showing debug info'))
            prelines = [
                'CLIENT VALUES:',
                'client_address=%s (%s)' % (self.client_address,
                                            self.address_string()),
                'command=%s' % self.command,
                'path=%s' % self.path,
                'real path=%s' % parsed_path.path,
                'query=%s' % parsed_path.query,
                'request_version=%s' % self.request_version,
                '',
                'SERVER VALUES:',
                'server_version=%s' % self.server_version,
                'sys_version=%s' % self.sys_version,
                'protocol_version=%s' % self.protocol_version,
                'thread=%s' % threading.currentThread().getName(),
                '',
                'HEADERS RECEIVED:',
            ]
            for name, value in sorted(self.headers.items()):
                prelines.append('%s=%s' % (name, value.rstrip()))
            prelines.append('')
            prelines = [_quote_html(aline.rstrip()) for aline in prelines]

        self.send_response(http_response_code)
        self.send_header('content-type', 'text/html')
        self.end_headers()

        host = self.headers['host']
        links = []
        links.append('<a href="http://%s/makehtml">/makehtml</a>' % host)
        links.append('<a href="http://%s/makehtml_no_cache">makehtml_no_cache</a>' % host)
        links.append('<a href="http://%s/show_warnings">/show_warnings</a>' % host)
        links.append('<a href="http://%s/show_stderr">/show_stderr</a>' % host)
        links.append('<a href="http://%s/show_stdout">/show_stdout</a>' % host)
        links.append('<a href="http://%s/show_cmd">/show_cmd</a>' % host)
        links.append('<a href="http://%s/debug_info">/debug_info</a>' % host)
        links.append('<a href="http://%s/shutdown">/shutdown</a>' % host)
        msglines.append('<br>| ' + ' | '.join(links) + ' |<br>')

        message2 = ''
        if prelines:
            prelines.insert(0, '<pre>')
            prelines.append('</pre>')
            prelines = ['%s\r\n' % aline for aline in prelines]

        message = '<br>\r\n'.join(msglines)
        message2 = ''.join(prelines)
        self.wfile.write(message + message2)
        return


class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    """Handle requests in a separate thread."""

if __name__ == '__main__':
    port = 9999
    if len(sys.argv) == 2:
        port = int(sys.argv[1])
    server = ThreadedHTTPServer(('0.0.0.0', port), GetHandler)
    print(
        'Starting server to run \'sphinx-build\'.\n'
        'Get http://127.0.0.1:%(port)s/makehtml to run sphinx-build.\n'
        'Use http://127.0.0.1:%(port)s/shutdown or <Ctrl-C> to stop.'
        % {'port': port})
    server.serve_forever()

.. include:: /Includes.rst.txt


======================================
Pull and use 'develop' from Docker hub
======================================

It can be a bit laborious to watch Docker hub for a new build of the
container and put that into work. This script helps.

Pull and or update `t3docs/render-documentation:develop`, find out, what tag
is used in there and do a `docker tag RENAME` so that - for example -
`t3docs/render-documentation:v2.3.0-develop` is available too.

my-update-dockrun_t3rd-develop.py:

.. code-block:: python

   #! /usr/bin/env python3
   # coding: utf-8

   # MIT license
   #
   # Copyright 2019 Martin Bless martin.bless@mbless.de
   #
   # Permission is hereby granted, free of charge, to any person obtaining a copy
   # of this software and associated documentation files (the "Software"), to deal
   # in the Software without restriction, including without limitation the rights
   # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   # copies of the Software, and to permit persons to whom the Software is
   # furnished to do so, subject to the following conditions:
   #
   # The above copyright notice and this permission notice shall be included in
   # all copies or substantial portions of the Software.
   #
   # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   # SOFTWARE.

   #  named: my-update-dockrun_t3rd-develop.py
   #  To be run from the commandline.

   import logging
   import subprocess

   from logging import log, INFO, WARNING
   from subprocess import PIPE

   logging.basicConfig(level=INFO)
   exitcode = CONTINUE = 0

   def runcmd(args):
       cp = subprocess.run(args, stdout=PIPE, stderr=PIPE)
       stats['runcmd'] = stats.get('runcmd', 0) + 1
       if 0:
           print('==========', stats['runcmd'], '==========')
           print(cp.args)
           print(cp.returncode)
           print(cp.stdout)
           print(cp.stderr)
       return cp.returncode, cp

   stats = {}
   our_image_tag = None
   name = 't3docs/render-documentation'
   tag_src = 'develop'
   tag_dest = None
   name_tag_src = '%s:%s' % (name, tag_src)
   name_tag_dest = None

   if exitcode == CONTINUE:
       log(INFO, f'Try update of: {name_tag_src}')
       exitcode, cp = runcmd(['docker', 'pull', name_tag_src])
       if exitcode:
           log(WARNING, 'Failure.')

   if exitcode == CONTINUE:
       if b'Downloaded newer image'.lower() in cp.stdout.lower():
           log(INFO, 'Success: Downloaded newer image.')
           exitcode, cp = runcmd(['docker', 'run', '--rm', name_tag_src, '--version'])

   if exitcode == CONTINUE:
       if b'Image is up to date'.lower() in cp.stdout.lower():
           log(INFO, 'Download not needed, image is up to date.')
           exitcode, cp = runcmd(['docker', 'run', '--rm', name_tag_src, '--version'])

   if exitcode == CONTINUE:
       msg = cp.stdout.decode('utf-8')
       for line in msg.splitlines():
           lineparts = line.split()
           if lineparts[0:2] == ['OUR_IMAGE_TAG', '::']:
               tag_dest = lineparts[2]
               break
       if tag_dest:
           name_tag_dest = f'{name}:{tag_dest}'
           log(INFO, f'Found destination tag: {name_tag_dest}')
       else:
           log(WARNING, f'Could not find destination tag.')

   if exitcode == CONTINUE:
       if name_tag_dest:
           log(INFO, f'Remove if exists: {name_tag_dest}')
           returncode, cp = runcmd(['docker', 'rmi', name_tag_dest])
           log(INFO, f'Create {name_tag_dest} from {name_tag_src}')
           exitcode, cp = runcmd(['docker', 'tag', f'{name_tag_src}',
                                  f'{name_tag_dest}'])

   if exitcode:
       log(WARNING, f'FAILURE. Final exitcode={exitcode}')
   else:
       log(INFO, f'SUCCESS. Final exitcode={exitcode}')

.. highlight:: text

Example run::

   ➜  ~ my-update-dockrun_t3rd-develop.py
   INFO:root:Try update of: t3docs/render-documentation:develop
   INFO:root:Download not needed, image is up to date.
   INFO:root:Found destination tag: t3docs/render-documentation:v2.3.0-develop
   INFO:root:Remove if exists: t3docs/render-documentation:v2.3.0-develop
   INFO:root:Create t3docs/render-documentation:v2.3.0-develop from t3docs/render-documentation:develop
   INFO:root:SUCCESS. Final exitcode=0
   ➜  ~

Another example run::

   ➜  ~ my-update-dockrun_t3rd-develop.py
   INFO:root:Try update of: t3docs/render-documentation:develop
   INFO:root:Success: Downloaded newer image.
   INFO:root:Found destination tag: t3docs/render-documentation:v2.4.0-dev
   INFO:root:Remove if exists: t3docs/render-documentation:v2.4.0-dev
   INFO:root:Create t3docs/render-documentation:v2.4.0-dev from t3docs/render-documentation:develop
   INFO:root:Write /home/marble/.dockrun/dockrun_t3rd/shell-commands.sh
   INFO:root:SUCCESS. Final exitcode=0
   ➜  ~


.. highlight:: shell

Create and save shell commands::

   docker run --rm t3docs/render-documentation:v2.3.0-develop \
              show-shell-commands \
              > ~/.docker-shell-commands.sh

Activate the dockrun function::

   source ~/.docker-shell-commands.sh

.. tip:: Add that file to :file:`.bashrc` or :file:`.zshrc` or similar:

         ::

            echo 'source ~/.docker-shell-commands.sh' >> ~/.bashrc

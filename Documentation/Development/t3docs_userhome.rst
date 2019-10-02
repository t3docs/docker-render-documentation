.. include:: /Includes.rst.txt

==========================
Use local 'userhome'
==========================

((This page: to be done))


Create a folder to keep things locally::

   mkdir -p ~/.dockrun/dockrun_t3rd


Get the `/ALL/userhome` folder of the container::

   cd /tmp
   dockrun_t3rd  export-ALL
   mv /tmp/Documentation-GENERATED-temp/ALL-exported/userhome \
      ~/.dockrun/dockrun_t3rd/

Use it::

   T3DOCS_DEBUG=1
   T3DOCS_USERHOME=/home/marble/.dockrun/dockrun_t3rd/userhome
   dockrun_t3rd

Example::

   ➜  ~ source ~/.docker-shell-commands-v2.sh
   This function is now defined FOR THIS terminal window:
       dockrun_t3rd

   ➜  ~ T3DOCS_DEBUG=1

   ➜  ~ T3DOCS_USERHOME=/home/marble/.dockrun/dockrun_t3rd/userhome

   ➜  ~ dockrun_t3rd
   PROJECT......: /home/marble
   creating: mkdir -p /home/marble/Documentation-GENERATED-temp
   RESULT.......: /home/marble/Documentation-GENERATED-temp
   USERHOME......: /home/marble/.dockrun/dockrun_t3rd/userhome
   OUR_IMAGE....: t3docs/render-documentation:v2.3.0-develop
   docker run --rm --user=1000:1000 \
      -v /home/marble:/PROJECT:ro \
      -v /home/marble/Documentation-GENERATED-temp:/RESULT \
      -v /home/marble/.dockrun/dockrun_t3rd/userhome:/ALL/userhome \
      t3docs/render-documentation:v2.3.0-develop
   t3rd - TYPO3 render documentation (v2.3.0-develop)
   For help:
      docker run --rm t3docs/render-documentation:v2.3.0-develop --help
      dockrun_t3rd --help

   ... did you mean 'dockrun_t3rd makehtml'?

   See manual (draft) at
   https://docs.typo3.org/m/typo3/t3docs-docker-render-documentation/draft/en-us/

   ➜  ~


Trick 17
========

::

   dockrun_t3rd makehtml  -c activateLocalSphinxDebugging 1


Trick 18
========

Install your own theme.

https://github.com/readthedocs/sphinx_rtd_theme/releases

https://github.com/readthedocs/sphinx_rtd_theme/archive/0.4.3.zip

::

   ➜  ~ T3DOCS_USERHOME=/home/marble/.dockrun/dockrun_t3rd/userhome

   ➜  ~ dockrun_t3rd /bin/bash

   docker run --rm --user=1000:1000 --entrypoint /bin/bash -it \
      -v /home/marble:/PROJECT:ro \
      -v /home/marble/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0-local



   ➜  ~


Recorded
========

::

   cd
   dockrun_t3rd export-ALL
   mkdir -p ~/.dockrun/dockrun_t3rd
   sudo chown -R $(id -u):$(id -g) ~/.dockrun
   rsync -av --delete Documentation-GENERATED-temp/ALL-exported/userhome \
      ~/.dockrun/dockrun_t3rd/
   sudo chown -R $(id -u):$(id -g) ~/.dockrun

.. code-block:: text

   ➜  ~ T3DOCS_USERHOME=/home/marble/.dockrun/dockrun_t3rd/userhome
   ➜  ~ T3DOCS_DEBUG=1
   ➜  ~ dockrun_t3rd /bin/bash
   PROJECT......: /home/marble
   creating: mkdir -p /home/marble/Documentation-GENERATED-temp
   RESULT.......: /home/marble/Documentation-GENERATED-temp
   USERHOME......: /home/marble/.dockrun/dockrun_t3rd/userhome
   OUR_IMAGE....: t3docs/render-documentation:v2.3.0
   docker run --rm --entrypoint /bin/bash -it \
      -v /home/marble:/PROJECT:ro \
      -v /home/marble/Documentation-GENERATED-temp:/RESULT \
      -v /home/marble/.dockrun/dockrun_t3rd/userhome:/ALL/userhome t3docs/render-documentation:v2.3.0
   (venv) root@5d80788d1bde:/ALL/venv# pipenv install ablog
   Installing ablog...
   Adding ablog to Pipfile's [packages]...
   ✔ Installation Succeeded
   Pipfile.lock (88c8ac) out of date, updating to (a323a5)...
   Locking [dev-packages] dependencies...
   Locking [packages] dependencies...
   ✔ Success!
   Updated Pipfile.lock (88c8ac)!
   Installing dependencies from Pipfile.lock (88c8ac)...
     🐍   ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉ 60/60 — 00:00:16
   (venv) root@5d80788d1bde:/ALL/venv# exit
   exit

   ➜  ~ sudo chown -R $(id -u):$(id -g) $T3DOCS_USERHOME

   ➜  ~



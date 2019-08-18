.. include:: ../Includes.txt

==========================
Use local 'userhome'
==========================

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



.. include:: /Includes.rst.txt

================
Menu development
================

((This page: to be done))


Menu development::

   ➜  project T3DOCS_DEBUG=1
   ➜  project T3DOCS_MENU=/home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Menu
   ➜  project dockrun_t3rd
   PROJECT......: /home/marble/project
   creating: mkdir -p /home/marble/project/Documentation-GENERATED-temp
   RESULT.......: /home/marble/project/Documentation-GENERATED-temp
   MENU.........: /home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Menu
   OUR_IMAGE....: t3docs/render-documentation:v2.3.0-local
   docker run --rm --user=1000:1000 \
      -v /home/marble/project:/PROJECT:ro \
      -v /home/marble/project/Documentation-GENERATED-temp:/RESULT \
      -v /home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Menu:/ALL/Menu t3docs/render-documentation:v2.3.0-local
   t3rd - TYPO3 render documentation (v2.3.0-local)
   For help:
      docker run --rm t3docs/render-documentation:v2.3.0-local --help
      dockrun_t3rd --help

   ... did you mean 'dockrun_t3rd makehtml'?

   ➜  project


# run container.

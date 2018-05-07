
((wip))

=========================================
TYPO3 Documentation Starter "Public Info"
=========================================

:Repository:      https://github.com/T3DocumentationStarter/Public-Info-000
:Published at:    https://docs.typo3.org/typo3cms/drafts/github/T3DocumentationStarter/Public-Info-000/
:Writing here:    My Name

((to be written))


.. highlight:: shell
.. default-role:: code


About
=====

This repo provide all parts to enable TYPO3 Documentation rendering.

You also can use this to render your documentation locally.

It's also used in CI to render documentations.

Requirements
============

- Docker

Usage
=====

::

   # go to the folder where the documentation starts
   cd MyProject/Documentation

   # run
   docker run -v "$PWD":/tmp/T3DOCDIR t3docs/render-documentation

The results are inside the new `MyProject/Documentation/_temp-generated` folder.

::

   docker_tct () {
      docker run -v "$PWD":/tmp/T3DOCDIR t3docs/render-documentation tct $@
   }


Install
=======

By running the docker image, Docker will pull it if not already persent.

If you want to build the docker image locally, clone the repository and
start a build::

   mkdir ~/Repositories
   cd ~/Repositories
   git clone https://github.com/TYPO3-Documentation/t3docs-docker-image
   cd ~/Repositories/t3docs-docker-image
   docker build -t t3docs/render-documentation .



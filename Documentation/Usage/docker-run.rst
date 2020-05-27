.. include:: /Includes.rst.txt

==================
Using 'docker run'
==================

Navigate this page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top



Basics
======

`docker run` is how you start. Commands can soon become long and complicated.
To overcome this a helper command `dockrun_t3rd` is available (Linux, Mac).
Read about that in :ref:`dockrun_t3rd-commands`.


Use `docker run`. This will initially download the image. For each run a copy
of the image is made and run as a container. To remove those copies right away
after usage add the `--rm` option. Play with these commands::

   docker run --rm t3docs/render-documentation
   docker run --help
   docker run --rm t3docs/render-documentation:latest
   docker run --rm t3docs/render-documentation:v2.3.0


::

   # list images
   docker image ls
   docker image ls | grep t3docs

::

   ➜  ~ docker run --rm t3docs/render-documentation:v2.3.0-local
   t3rd - TYPO3 render documentation (v2.3.0-local)
   For help:
      docker run --rm t3docs/render-documentation:v2.3.0-local --help
      dockrun_t3rd --help

   ... did you mean 'dockrun_t3rd makehtml'?

   ➜  ~

::

   ➜  ~ docker run --rm t3docs/render-documentation:v2.3.0-local show-shell-commands

   # NOTE
   # You can 'source' this file directly into the shell at your command line with:
   #     source <(docker run --rm t3docs/render-documentation:v2.3.0-local show-shell-commands)
   # ATTENTION:
   #     No whitespace between '<('

   # the usual worker command like 'dockrun_t3rd'
   function dockrun_t3rd () {

   ...
   ➜  ~

Advanced
========

Run a BASH command in the container::

   ➜  ~ docker run --rm --entrypoint /bin/bash \
        t3docs/render-documentation:v2.3.0-local -c pwd
   /ALL/venv
   ➜  ~

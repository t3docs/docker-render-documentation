.. include:: ../Includes.txt

==================
Using 'docker run'
==================

Navigate this page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top



001
============

Use `docker run`. This will initially download the image. For each run a copy
of the image is made and run as a container. To remove those copies right away
after usage add the `--rm` option. Play with these commands::



   docker run --rm t3docs/render-documentation
   docker run --help
   docker run --rm t3docs/render-documentation:latest
   docker run --rm t3docs/render-documentation:v2.3.0



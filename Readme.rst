.. _highlight: bash

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

``cd`` into an extension folder, containing the ``Documentation`` folder.

Run::

    docker run -v "$PWD":/tmp/makedir t3docs/renderdocumentation

The results are inside the new ``build`` folder.

Install
=======

By running the docker image, Docker will pull it if not already persent.

If you want to build the docker image locally, clone the repository and run::

    docker build -t t3docs/renderdocumentation .

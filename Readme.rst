.. _highlight: bash

About
=====

This repo should provide all parts to enable TYPO3 Documentation rendering through Gitlab CI.

You also can use this to render your documentation locally the same way.

Requirements
============

- Docker

Install
=======

::

    docker build -t danielsiepmann/t3docs-ci .

Usage
=====

``cd`` into an extension folder, containing the ``Documentation`` folder.

Run::

    docker run -v "$PWD":/tmp/makedir danielsiepmann/t3docs-ci

The results are inside the new ``build`` folder.

.. include:: ../Includes.txt


======================================
Non TYPO3 usage
======================================

With alabaster
==============

Using the container you can `sphinx-quickstart` a documentation project.
As if you had installed Sphinx locally. Uses 'alabaster' theme.

((show how))


With sphinx_rtd_theme
=====================

The container has the sphinx_rtd_theme installed. So, if you change
`html_theme = 'alabaster'` in `conf.py` of the `sphinx-quickstart` project
to `html_theme = 'sphinx_rtd_theme'` you get the well known "ReadTheDocs"
theme.

...

With your own theme
===================

((...))

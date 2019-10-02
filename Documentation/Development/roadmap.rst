.. include:: /Includes.rst.txt

.. _roadmap:

=============================
Container development roadmap
=============================

January 2019
============

*  v1.6.11-html
*  v1.6.11-full

Debian based, large, "proof of concept" versions that nevertheless work.
Difficult to explain and having lots of "technical depths".


July 2019
=========

*  v2.2.6

Ubuntu 18.04 base, small, much cleaner, some of the technical depths dissolved.

Has issues:

*  There still are issues with security, as pointed out by the TYPO3 security
   team.

*  Prettyprints the html code while postprocessing, which seems to introduce
   unwanted blanks in the html pages.



August 19, 2019
===============

*  Release of v2.3.0

Cleaner, technical depths reduced, more functionality, online manual added,
can build html, singlehtml, package.zip, latex.

Should prevent 'javascript:' and 'data:' vulnerabilites of a.href and img.src.

Allows passing all parameters from just one source `jobfile.json`.

Adds data in `_buildinfo` that can be used at docs.typo3.org deployment to
generate Google sitemap files.

Improves SEO by adding `rel="nofollow noopener"` to external links if not
pointing to `*.typo3.org` or `*.typo3.com`.

Uses Python2.7 internally. Python2 is deprecated and support ends in 2020.

Uses Sphinx 1.8.5 due to being stuck on Python2.





What needs to be done next
==========================

*  Upgrade everything to Python 3

*  Having Python 3, upgrade Sphinx to latest version 2.x

*  Care about the issues regarding our theme t3SphinxThemeRtd

   Our theme is based on version of the `sphinx_rtd_theme` that is older than
   four years but has developed since then. Consider a rebase?


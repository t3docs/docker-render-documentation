Release v2.2.5 (released June 22, 2019)
=======================================

* Build again, make sphinx-contrib-slide-t3v1.0.1.zip available


Release v2.2.4 (released June 22, 2019)
=======================================

Bugs fixed
----------

*  Solve `issue #72 of container
   <https://github.com/t3docs/docker-render-documentation/issues/72>`__
   "Sphinx directive 'slide' not working". Explained `here
   <https://github.com/TYPO3-Documentation/sphinx-contrib-slide>`__.

Features added
--------------

*  The `.. slide::` directive can now embed "Google documents" and "Google
   spreadsheets" as well. Explained `here
   <https://github.com/TYPO3-Documentation/sphinx-contrib-slide>`__.

Use toolchain v2.6.0
--------------------

| ffbd087 Dump info to stdout if there are forbidden include files
| f68ebf0 Dump warnings.txt to stdout if not in _buildinfo
| 4606616 Add rel="nofollow noopener" to external + foreign links
| ee6533e Return sitemap-files in .txt format and not .json as result
| ec9fb21 Provide sitemap-files as .txt file too
| 4d65da1 v2.6.0 Set new version number


Release v2.2.1 (released June 14, 2019)
=======================================

Bugfix version

*  Fix logic error (don't always assume singlehtml)
*  Use TCT v0.4.1 showing ms = milli seconds
*  Use toolchain v2.5.1


Release v2.2.0 (released June 14, 2019)
=======================================

Enhancements
------------

*  Issues #63, #64 done in toolchain
*  Finetuned output of mainmenu.sh
*  Allow 'T3DOCS_DRY_RUN=1 dockrun_t3rd makehtml'
*  Allow 'dockrun_t3rd export-ALL' to copy the container internals to the host


Use toolchain RenderDocumentation v2.5.0
-----------------------------------------

*  Don't offer docs/manual.sxw as possibility
*  Solve `issue #64 of t3docs/docker-render-documentation
   <https://github.com/t3docs/docker-render-documentation/issues/64>`__
   "Weird appearance of README" rendering
*  Collect sitemap files `issue #63 of t3docs/docker-render-documentation
   <https://github.com/t3docs/docker-render-documentation/issues/63>`__
*  Postprocess html files: prettify, sanitize neutralize javascript links
   `issue #67 of t3docs/docker-render-documentation
   <https://github.com/t3docs/docker-render-documentation/issues/67>`__
*  Signal 'has_neutralized_links' in _builtinfo/results.json


Security fixes
--------------

*  Disable raw-directive `issue #65 of t3docs/docker-render-documentation
   <https://github.com/t3docs/docker-render-documentation/issues/65>`__
*  Issues #67 done in toolchain


Release v2.1.0 (released May 29, 2019)
======================================

Enhancements
------------

*  `#11: <https://github.com/t3docs/docker-render-documentation/issues/11>`__
   Again: Improve the output of "Find the results:"

*  `#50 <https://github.com/t3docs/docker-render-documentation/issues/50>`__
   Now installing specific versions from Pipfile


Bugs fixed
----------

*  `#51: <https://github.com/t3docs/docker-render-documentation/issues/51>`__
   Sphinx caching is working again. Removed recommonmark parser.

*  `#54: <https://github.com/t3docs/docker-render-documentation/issues/54>`__
   Have markdown files converted to rst by pandoc.

*  `#58: <https://github.com/t3docs/docker-render-documentation/issues/58>`__
   Catch YAML parser errors the better way.


Significant internal changes
----------------------------

*  `#55: <https://github.com/t3docs/docker-render-documentation/issues/55>`__
   Use /ALL/venv as workdir, remove folder /ALL/Rundir



Release v2.0.0 (released May 25, 2019)
======================================

This is a complete revamp of v1.6 of branch '1-6'.


Characteristics
---------------

*  codename 'dockrun_t3rd'
*  based on image ubuntu:18.04
*  almost migrated to Python 3
*  using pipenv as Python packet manager
*  only for html and singlehtml
*  much smaller in size


Enhancements
------------

*  `#11 <https://github.com/t3docs/docker-render-documentation/issues/11>`__
   Improve the output of "Find the results:"

*  `#53 <https://github.com/t3docs/docker-render-documentation/issues/53>`__
   Load `these sphinx extensions
   <https://github.com/t3docs/docker-render-documentation/blob/8fc0989c0e61cfd55b060b7fbefd138c910d87a3/ALL-for-build/Makedir/conf.py#L165>`__
   by default



Features added
--------------

*  `#20 <https://github.com/t3docs/docker-render-documentation/issues/20>`__
   Add sphinxcontrib.phpdomain


Bugs fixed
----------

*  `#03: <https://github.com/t3docs/docker-render-documentation/issues/3>`__
   Fix sphinxcontrib.googlemaps

*  `#18: <https://github.com/t3docs/docker-render-documentation/issues/18>`__
   Fix sphinxcontrib.googlemaps

*  `#31: <https://github.com/t3docs/docker-render-documentation/issues/31>`__
   Fix rendering of standalone README.(rst|md)

*  `#52: <https://github.com/t3docs/docker-render-documentation/issues/52>`__
   Fix sphinxcontrib.googlechart



Previous v1.6 releases (forked May 25, 2019)
============================================

Maintained in branch `1-6
<https://github.com/t3docs/docker-render-documentation/tree/1-6>` __


Release v1.6.11-html (released May 23, 2018)
============================================

Bugs fixed
----------

* typoscript syntax highlighter should now always succeed
* PDF generation working again

Features added
--------------

* update mtime of repo files automatically if 'git-restore-mtime' is in path

Info
----

* improved toolchain
* as before: uses Sphinx caching
* standalone *.zip is much smaller, as most fonts aren't shipped any more


Release v1.6.9-full (released May 10, 2018)
===========================================

...


Release v1.6.6 (released May 2, 2018)
=====================================

...


Release v1.6.4 (released Nov 16, 2017)
======================================

* Bump version from v0.6.3 to v1.6.4
* Use toolchain RenderDocumentation v2.2.0


Release v0.6.3 (released at the beginning of time)
==================================================

...


Contributing here
=================

Some recommended headlines:

| Bugs fixed
| Dependencies
| Deprecated
| Features added
| Features removed
| Enhancements
| Incompatible changes
| Significant internal changes

Maximum characters per line: 79 (except longlinks)

         1         2         3         4         5         6         7

1234567890123456789012345678901234567890123456789012345678901234567890123456789

End of CHANGES.

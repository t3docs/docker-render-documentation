Release v3.2.0 (2023-07-06)
===========================

*  Use sphinx_typo3_theme v4.9.0


Release v3.1.0 (2023-06-23)
===========================

*  Add DOCKRUN_FN_QUIET to show-shell-commands
*  Use sphinx_typo3_theme v4.8.0
*  Release as ghcr.io/t3docs/render-documentation:v3.1.0
*  Release as ghcr.io/t3docs/render-documentation:latest


Release v3.0.0 (2023-06-13)
===========================

From branch master:

* Release as ghcr.io/t3docs/render-documentation:v3.0.0
* Release as ghcr.io/t3docs/render-documentation:latest


Release v3.0.dev31 (2023-06-12)
===============================

*  Update README.rst

*  Use sphinx_typo3_theme v4.7.10 (= master).
   Line numbers of codeblocks aren't included
   and selected any more when copying.

*  Use toolchain 'RenderDocumentation v3.2.0'.
   This should fix some layout problems caused by the fact,
   that Docutils inserts css class 'container' which is
   also used by the Bootstrap layout package.
   Those classes get renamed to 'du-container'.

*  Dockerfile.build.sh now knows about an option
   PLANTUML_JAR_VERSION which can be used in junction
   with the 'make build' command. Run 'make' for an
   example.

Release v3.0.dev30 (2022-09-23)
===============================

*  Use sphinx_typo3_theme v4.7.9


Release v3.0.dev29 (2022-09-23)
===============================

*  Use sphinx_typo3_theme v4.7.8


Release v3.0.dev28 (2022-09-05)
===============================

*  Use sphinx_typo3_theme v4.7.7


Release v3.0.dev27 (2022-07-25)
===============================

*  Use sphinx_typo3_theme v4.7.6


Release v3.0.dev26 (2022-07-15)
===============================

*  Use sphinx>=4.5.0,<5.0


Release v3.0.dev25 (2022-07-12)
===============================

*  Test suite for DRC was successfully run
*  Updated: mainmenu.sh, now also knows T3DOCS_GIT_RESTORE_MTIME=1 (or 0)
*  Improved and bugfixed: 'make build' and 'Dockerfile.build.sh'
*  Use sphinx_typo3_theme 4.7.5


Release v3.0.dev24 (2022-05-17)
===============================

*  BUGFIX: Fix quoting of $@ in mainmenu.sh


Release v3.0.dev23 (2022-05-09)
===============================

*  BUGFIX: Fix quoting of $@ in mainmenu.sh


Release v3.0.dev22 (2022-05-09)
===============================

*  Use TCT v1.3.0
*  Use Theme v4.7.3
*  Use Toolchain v3.1.0


Release v3.0.dev21 (2022-05-05)
===============================

*  Use theme v4.7.3


Release v3.0.dev20 (2022-05-04)
===============================

*  Use sphinxcontrib-docstypo3.git@v1.0.dev5
*  Use theme v4.7.2


Release v3.0.dev19 (2022-05-04)
===============================

*  Use theme v4.7.1

Release v3.0.dev18 (2022-04-26)
===============================

*  update conf.py: do not load sphinxcontrib.t3targets by default

Release v3.0.dev16 (2022-04-23)
===============================

*  use latest sphinx_typo3_theme v4.7.dev (+scm version)
*  use latest toolchain 2.12.dev4


Release v3.0.dev13 (2022-04-06)
===============================

*  update conf.py, Default.cfg: Add section [sphinx_object_types_to_add]


Release v3.0.dev12 (2022-02-15)
===============================

*  update conf.py: add toml, strip types from confval
*  use custom sphinxcontrib-phpdomain@develop-for-typo3


Release v3.0.dev11 (2021-12-xx)
==============================

*  update conf.py
*  Allow list-like string in Settings.cfg for 'graphviz_dot_args'
*  update extlinks, adding 't3ext' and 'packagist'
*  work on EditButton for GitHub, Bitbucket, GitLab
*  Update docutils.conf


Release v3.0.dev10 (2021-12-14)
==============================

* Turn parallel reading off with sphinxcontrib.t3targets/archive/v0.3.5.zip


Release v3.0.dev9 (2021-12-13)
==============================

*  Update sphinxcontrib.docstypo3 and use v1.0.dev4
*  Use sphinx_typo3_theme v4.7.dev6

   *  Create project links in footer not only when rendering for docs.typo3.org


Release v3.0.dev7 (2021-11-01)
==============================

*  Add sphinxcontrib.docstypo3

Release v3.0.dev6 (2021-11-06)
==============================

*  Set nitpick_ignore_regex in conf.py.

Release v3.0.dev5 (2021-11-06)
==============================

*  Use newer toolchain.
*  Use newer theme

Release v3.0.dev4 (2021-11-05)
==============================

*  Update docutils.conf
*  Add Sphinx extension sphinxcontrib.collections

Release v3.0.dev3 (2021-11-02)
==============================

*  [FEATURE]] Add Sphinx extension "sphinx-tabs"
   https://sphinx-panels.readthedocs.io/en/latest/

*  Includes latest version of the theme with Display Settings Options like
   'Use full width' and 'Make settings permanent'.


Release v3.0.dev2 (2021-10-20)
==============================

*  [MAJOR CHANGE] Use newer versions:

   *  Python v3.8.10 (was v2.7)
   *  Sphinx v4.2.x (was v1.8.5)
   *  sphinx_typo3_theme >=4.7.dev1
   *  tct >=1.2.0
   *  toolchain_RenderDocumentation v2.12.dev1

Release v2.9.0 (2021-07-22)
===========================

*  [FEATURE] Use sphinx_typo3_theme >=4.6 with global search
*  [FEATURE] Add sphinx-copybutton to code-blocks


Release 'develop' (v2.8.3 (2021-03-29)
======================================

*  [FEATURE] Add just1sphinxbuild functionality


Release v2.8.2 (2021-03-27)
===========================

*  [FEATURE] Add serve4build functionality


Release v2.8.1 (Mar 26, 2021)
============================

*  Use sphinx_typo3_theme v4.5.2
*  Disable autoSelect for Sphinx search autocompletion
*  Set h2edit_url in Overrides.cfg
*  Link "How to edit" to proper URL and show always and not as hover effect
*  Constrain area of logo link to actual image


Release v2.8.0
============================

*  Using sphinx_typo3_theme v4.5.1
*  How to edit button
*  Sphinx can use parallel processes
*  Collapsed menu for TYPO3 Exceptions
*  Removed: Full width for extra wide screens


Release v2.7.1 (Jan 6, 2021)
============================

*  Use sphinx_typo3_theme v4.4.2 with styled Index page


Release v2.7.0 (Dec 16, 2020)
=============================

New
---

*  42e0120 Show OS_NAME and OS_VERSION in versioninfo
*  111c165 Use Ubuntu 20.04
*  f5efcb3 Add Graphviz
*  8b81f71 Add PlantUML
*  1eb5b7a `exclude_patterns` can be specified in Defaults.cfg, Settings.cfg,
   Overrides.cfg


Removed
-------

*  7fcc524 Remove sphinxcontrib.googlemaps - doesn't work any more
*  c074131 Drop Sphinx extension googlechart - Google stopped service


Important commits
-----------------

*  e5165c2 Use Toolchain v2.11.0
*  e15ff08 Add Sphinx extension sphinx-tabs
*  74c96c8 Update dockrun_t3rd.bat - Tested batch file for Windows
*  f0758b7 Add dockrun_t3rd.bat for Windows users
*  7fcc524 Remove sphinxcontrib.googlemaps
*  42e0120 Show OS_NAME and OS_VERSION in versioninfo
*  c074131 Drop Sphinx extension googlechart
*  111c165 Use Ubuntu 20.04
*  f5efcb3 Add Defaults.cfg, update conf.py, add Graphviz - Martin Bless
*  8b81f71 Merge pull request #97 from alexander-nitsche/feature/sphinx-plantuml
*  1eb5b7a [FEATURE] Implement Issue 98, exclude_patterns


Release v2.6.1 (May 26, 2020)
=============================

*  Bugfix: Make on-the-fly installation of Sphinx extensions from /WHEELS work.


Release v2.6.0 (May 11, 2020)
=============================

Using `sphinx_typo3_theme v2.4.0`, `sphinxcontrib.gitloginfo v1.0.0` (new),
toolchain `RenderDocumentation v2.10.1`.

*  Toolchain: FINAL_EXIT_CODE should now be trustworthy and either have
   value `0` (success) or value `255` (failure). `0` means, the toolchain
   came to an end and at least the step "build html" was successful.
   `255` indicates a failure where either the toolchain didn't come to normal
   end or html wasn't built.

*  Theme: 'last modified' date appears in page html head section if
   available.

*  Theme: 'Last updated' in the page footer with a link to the latest commit.

*  Theme: Search result pages with highlighted search text show a link to
   deselect the hightlighting.

*  Theme: The intra page menu is now appended to the left menu column to fix
   the - so called - "missing third menu level" issue.

*  Theme: The logo is now defineable in the theme configuration file
   `theme.conf`.

*  Toolchain: `dockrun_t3rd makehtml -c allow_unsafe 1` to skip the extensive
   and time consuming html postprocessing, to skip file include checks and to
   allow the reST 'raw' directive.

*  Toolchain: `dockrun_t3rd makehtml -c sphinxVerboseLevel n'. With `n=3`
   the Sphinx build will be started with three times `-v`. This would mean
   `sphinx-build -v -v -v …`

Bug fixes:

*  Theme: Remove false warnings about illegal theme options
*  Toolchain: Remove pip warnings about 'Cache dir not writable'.



Release v2.5.1 (Feb 26, 2020)
=============================

*  Use toolchain v2.9.1: Fix static files


Release v2.5.0 (Feb 25, 2020)
=============================

*  Use develop.zip of Sphinx extension t3targets to fix
   https://github.com/t3docs/docker-render-documentation/issues/80 Line numbers
   point to *.txt instead of *.rst.txt
   Fixed with `b0d6a7
   <https://github.com/t3docs/docker-render-documentation/commit/b0d6a7e743f437461fa571061fcb0963a9003589>`
   and
   https://github.com/TYPO3-Documentation/sphinxcontrib.t3targets/releases/tag/v0.3.0

*  Use sphinx_typo3_theme from PyPi
*  Use toolchain v2.9.0
*  Add T3DOCS_WHEELS folder. If it contains Python wheel packages, those get
   installed within the container prior to rendering. So this is an easy way to
   extra install Python packages prior to rendering.



Release v2.4.0 (Oct 21, 2019)
=============================

*  Add 'dockrun_t3rd  /usr/bin/bash'
*  Use Toolchain v2.8.0
*  Use TCT v1.1.0
*  Account for /THEMES mapping
*  Add 'ablog' to Pipfile
*  6ff41f3 List localizations in 'Find the results'
*  8785da4 Add directive and textrole 'confval' in conf.py



Release v2.3.0 (August 19, 2019)
================================

*  Use toolchain >= v2.7.1



Release v2.2.6 (released June 23, 2019)
=======================================

*  Use bugfixed toolchain v2.6.1



Release v2.2.5 (released June 22, 2019)
=======================================

*  Build again, make sphinx-contrib-slide-t3v1.0.1.zip available



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

*  typoscript syntax highlighter should now always succeed
*  PDF generation working again

Features added
--------------

*  update mtime of repo files automatically if 'git-restore-mtime' is in path

Info
----

*  improved toolchain
*  as before: uses Sphinx caching
*  standalone *.zip is much smaller, as most fonts aren't shipped any more



Release v1.6.9-full (released May 10, 2018)
===========================================

...



Release v1.6.6 (released May 2, 2018)
=====================================

...



Release v1.6.4 (released Nov 16, 2017)
======================================

*  Bump version from v0.6.3 to v1.6.4
*  Use toolchain RenderDocumentation v2.2.0



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

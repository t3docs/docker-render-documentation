.. include:/Includes.rst.txt

.. _start:

============================================================
Docker container v2.6.1 for documentation rendering and more
============================================================

--------------------------------------
Comprehensive manual
--------------------------------------

.. tip:: Latest release - recommended for use

   **TYPO3 docker container for documentation rendering**

   RELEASED May 27, 2020: v2.6.1

   Pull and run::

      docker pull t3docs/render-documentation:v2.6.1
      docker run --rm t3docs/render-documentation:v2.6.1

   or, as of today, the 'latest' version. ::

      docker pull t3docs/render-documentation
      docker run --rm t3docs/render-documentation

   The latest version is intended to always be a "good" and working version.
   It may reflect a more advanced development state in between the latest
   released version and the next version.


   **NEW:** `Documentation about the container
   <https://docs.typo3.org/m/typo3/t3docs-docker-render-documentation/draft/en-us/>`__

   If you encounter problems please `create an issue at github
   <https://github.com/t3docs/docker-render-documentation/issues/>`__.



-----
See also

See chapter
`How to render documentation
<https://docs.typo3.org/m/typo3/docs-how-to-document/master/en-us/RenderingDocs/>`_
in `Writing documentation
<https://docs.typo3.org/m/typo3/docs-how-to-document/master/en-us/>`_.




-----

Helper links while in draft status:

:Describing:    \• Container version >=v2.6.1
:Github:        \• `Github documentation-draft <https://github.com/t3docs/docker-render-documentation/tree/documentation-draft>`__
:Public draft:  \• https://docs.typo3.org/m/typo3/t3docs-docker-render-documentation/draft/en-us/
:Private draft: \• `symlinked.local.mbless.de <http://symlinked.local.mbless.de/docker-render-documentation-draft/>`__
:Docker tags:   \• `Docker hub tags <https://hub.docker.com/r/t3docs/render-documentation/tags/>`__
:Autobuilds:    \• `Docker cloud autobuilds <https://cloud.docker.com/u/t3docs/repository/docker/t3docs/render-documentation/builds>`__
:Github:        \• https://github.com/t3docs/docker-render-documentation/tree/develop
:Buildinfo:     \• `_buildinfo <_buildinfo>`__ • `warnings.txt <_buildinfo/warnings.txt>`__ • `results.json <_buildinfo/results.json>`__
:Intercept:     \• `t3docs <https://intercept.typo3.com/admin/docs/deployments?docs_deployment_filter%5Bsearch%5D=t3docs&docs_deployment_filter%5Btype%5D=&docs_deployment_filter%5Bstatus%5D=&docs_deployment_filter%5Btrigger%5D=>`__
                \• `recent actions <https://intercept.typo3.com/admin/docs/deployments?docs_deployment_filter[search]=&docs_deployment_filter[type]=&docs_deployment_filter[status]=4&docs_deployment_filter[trigger]=>`__
                \•
:In one file:   \• `singlehtml <singlehtml>`__
:See also:      \• Sphinx docs: `index directive <https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-index>`__ •
:Rendered:      \• |today|

-----

:Author:          TYPO3 documentation team
:Initial author:  Martin Bless <martin.bless@typo3.org>
:Maintainer:      Martin Bless <martin.bless@typo3.org>
:License:
   This extension documentation is published under the Creative Commons license
   `CC BY-NC-SA 4.0 <https://creativecommons.org/licenses/by-nc-sa/4.0/>`__.

-----

**About this manual**

Everything about the container: How it works, how it's developed,
how it is built and ways of using it.

This container is a beast, it has lots of features and lots of knowledge
built in. This manual hopefully helps to access the features.

The container is used for rendering the official TYPO3 documentation
on the docs server.

-----

.. _operating-systems:

**Operating systems**

For Linux, Mac and Windows.

At its core Docker is a Linux solution. `Docker Machine
<https://docs.docker.com/machine/overview/>`__ has come to make it run on Mac
and Windows as well. The container will run just the same on Linux, Mac and
Windows.

However, most of this manual is written from the perspective of a Linux user
when it comes to "How to use the container."

If you are on Windows and can help to port the solutions to Windows - you are
welcome. Very much!

-----

**TYPO3**

The content of this document is related to TYPO3 CMS, a GNU/GPL CMS/Framework
available from https://typo3.org/.

-----

.. note::

   **Highlights of v2.6.1**

   * With `sphinx_typo3_theme v4.2.1` there now is a headline "PAGE CONTENTS"
     above the menu of intra-page links.

   * Bugfix: If the container finds Python packages in wheel format in
     `/WHEELS` these will be installed on the fly before rendering. This now
     works. Thus, for example, a new package with the theme may easily be
     tested.

   **Highlights of v2.6.0**

   Using `sphinx_typo3_theme v4.2.0`, `sphinxcontrib.gitloginfo v1.0.0` (new),
   toolchain `RenderDocumentation v2.10.1`.

   * Toolchain: FINAL_EXIT_CODE should now be trustworthy and either have
     value `0` (success) or value `255` (failure). `0` means, the toolchain
     came to an end and at least the step "build html" was successful.
     `255` indicates a failure where either the toolchain didn't come to normal
     end or html wasn't built.

   * Theme: 'last modified' date appears in page html head section if
     available.

   * Theme: 'Last updated' in the page footer with a link to the latest commit.

   * Theme: Search result pages with highlighted search text show a link to
     deselect the hightlighting.

   * Theme: The intra page menu is now appended to the left menu column to fix
     the - so called - "missing third menu level" issue.

   * Theme: The logo is now defineable in the theme configuration file
     `theme.conf`.

   * Toolchain: `dockrun_t3rd makehtml -c allow_unsafe 1` to skip the extensive
     and time consuming html postprocessing, to skip file include checks and to
     allow the reST 'raw' directive.

   * Toolchain: `dockrun_t3rd makehtml -c sphinxVerboseLevel n'. With `n=3`
     the Sphinx build will be started with three times `-v`. This would mean
     `sphinx-build -v -v -v …`

   Bug fixes:

   * Theme: Remove false warnings about illegal theme options
   * Toolchain: Remove pip warnings about 'Cache dir not writable'.

   Beauty:

   * Generated html code is looking much nicer!


.. note::

   **Highlights of v2.5.1**

   * `dockrun_t3rd makehtml -c remove_docutils_conf 1` to allow the reST 'raw'
     directive


.. note::

   **Highlights of v2.4.0**

   * new: powerful :file:`jobfile.json` can configure everything
   * new: 'confval' directive and textroles
   * new: 'include' and 'literalinclude' can access every file of the project,
     not just those in ./Documentation/ :ref:`(read more)
     <specify-documentation-files>`
   * new: use absolute paths for includes, like
     `.. include:: /Includes.rst.txt` :ref:`(read more) <about-includes>`
   * new: use your own custom Sphinx theme or do :ref:`theme development
     <theme-development>`
   * fixed: rendering of localized manuals

.. note::

   **Highlights of v2.3.0**

   •  much smaller image
   •  caching works
   •  can create html, singlehtml, latex, package
   •  all sphinx extensions included and working
   •  security improved: xss prevented when rendering for the server
   •  security improved: raw-directive disabled

-----

.. todolist::

-----

**Roadmap**

:ref:`roadmap`

-----


.. rubric:: Content
.. rst-class:: compact-list
.. toctree::

   Usage/Index
   Usage-Windows/Index
   Structures/Index
   Rendering/Index
   Building/Index
   Explanation/Index
   Inspection/Index
   Development/Index
   Solutions/Index
   Whatsnew/Index
   Glossary
   Targets
   Sitemap
   genindex

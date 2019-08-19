
.. include:: Includes.txt


.. _start:

==============================================
Documentation Rendering with Sphinx and Docker
==============================================

--------------------------------------
Manual for t3docs/render-documentation
--------------------------------------

t3docs/render-documentation is the TYPO3 Docker container that can be used to
render documentation for all TYPO3 projects. It can be used wherever Docker is
running.

The container is used to do the "official rendering" for manuals shown on
https://docs.typo3.org.

-----

DRAFT + DRAFT + DRAFT + DRAFT + DRAFT + DRAFT + DRAFT + DRAFT + DRAFT + DRAFT

-----

.. admonition:: Latest release - recommended for use

   **TYPO3 docker container for documentation rendering**

   RELEASED August 19, 2019: v2.3.0

   Pull and run::

      docker pull t3docs/render-documentation:v2.3.0
      docker run --rm t3docs/render-documentation:v2.3.0


   **NEW:** `Documentation about the container
   <https://docs.typo3.org/m/typo3/t3docs-docker-render-documentation/draft/en-us/>`__

   If you encounter problems please `create an issue at github
   <https://github.com/t3docs/docker-render-documentation/issues/>`__.


-----

Helpers while in draft status:

:Github:        https://github.com/t3docs/docker-render-documentation/tree/documentation-draft
:Public draft:  https://docs.typo3.org/m/typo3/t3docs-docker-render-documentation/draft/en-us/
:Private draft: http://symlinked.local.mbless.de/docker-render-documentation-draft/
:Docker tags:   https://hub.docker.com/r/t3docs/render-documentation/tags/
:Autobuilds:    https://cloud.docker.com/u/t3docs/repository/docker/t3docs/render-documentation/builds
:Buildinfo:     `_buildinfo <_buildinfo>`_
:In one file:   `singlehtml <singlehtml>`__
:Rendered:      |today|

-----

:Container:
   Version 2.3.0

:Language:
   en

:Authors:
   TYPO3 documentation team

:Main caretaker:
   Martin Bless <martin.bless@typo3.org>

:License:
   This extension documentation is published under the Creative Commons license
   `CC BY-NC-SA 4.0 <https://creativecommons.org/licenses/by-nc-sa/4.0/>`__.

**TYPO3**

   The content of this document is related to TYPO3 CMS, a GNU/GPL
   CMS/Framework available from https://typo3.org/.


**Sitemap**

   :ref:`sitemap`

.. tip::

   **Highlights**

   * much smaller image
   * caching works
   * can create html, singlehtml, latex, package
   * all sphinx extensions included and working
   * security improved: xss prevented when rendering for the server
   * security improved: raw-directive disabled


.. todolist::


**Available pages**

.. rst-class:: compact-list
.. toctree::
   :glob:
   :titlesonly:

   Usage/Index
   Structures/Index
   Rendering/Index
   Building/Index
   Explanation/Index
   Development/Index
   Solutions/Index
   *

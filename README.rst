================================
DRC - Docker Rendering Container
================================

.. attention::

   2021-10-20 (tag 'develop')

   The image used to be distributed via Docker hub. However, since Docker hasn't
   granted a free plan for TYPO3 yet we are currently switching to GitHub's
   package repository https://ghcr.io/

   WAS::

      docker pull t3docs/render-documentation:develop
      eval "$(docker run --rm t3docs/render-documentation:develop show-shell-commands)"

   IS NOW::

      docker pull ghcr.io/t3docs/render-documentation:develop
      docker tag ghcr.io/t3docs/render-documentation:develop \
                         t3docs/render-documentation:develop
      eval "$(docker run --rm t3docs/render-documentation:develop show-shell-commands)"


What is this?
=============

Use this repository and `docker build` to build the TYPO3 official Docker image
`t3docs/render-documentation` for rendering TYPO3 documentation.

:Repository:      https://github.com/t3docs/docker-render-documentation
:Version:         develop (v3.0.dev19)
:Authors:         TYPO3 Documentation Team
:Main caretaker:  Martin Bless <martin.bless@mbless.de>
:Documentation:   `The T3DocsRenderingContainer (Draft)
                  <https://docs.typo3.org/m/typo3/T3DocsRenderingContainer/draft/en-us/>`__
:Documentation repository:
                  `GitHub rendering-container-documentation@documentation-draft
                  <https://github.com/t3docs/rendering-container-documentation/tree/documentation-draft>`__


Docker hub
==========

** DO NOT USE at the moment for tag `develop` (2021-10-20)!**

Usually we have been using Docker hub as registry for our Docker image. However,
Docker hasn't granted a free plan to us yet. This means, Docker hub DOES NOT
host the latest version at the moment and you should not use the usual `docker
pull t3docs/render-documentation:develop` command. Use `GitHub registry`_
instead.

:Docker image:    t3docs/render-documentation:develop
:Docker hub:      https://hub.docker.com/r/t3docs/render-documentation/
:Docker tags:     https://hub.docker.com/r/t3docs/render-documentation/tags/


GitHub registry
===============

** USE THIS at the moment (2021-10-20) for tag `develop`!**

:GitHub image:    ghcr.io/t3docs/render-documentation:develop


Getting the image from GitHub::

   # pull
   docker pull ghcr.io/t3docs/render-documentation:develop

   # Assign our usual tag `t3docs/render-documentation:develop`
   docker tag ghcr.io/t3docs/render-documentation:develop \
                      t3docs/render-documentation:develop

   # Define the helper function `dockrun_t3rd`
    eval "$(docker run --rm t3docs/render-documentation:develop show-shell-commands)"


Using the image::

   # some (educational) example calls
   #
   docker run --rm ghcr.io/t3docs/render-documentation:develop
   docker run --rm t3docs/render-documentation:develop
   docker run --rm t3docs/render-documentation:develop --help
   #
   # define 'dockrun_t3rd'
   eval "$(docker run --rm t3docs/render-documentation:develop show-shell-commands)"
   dockrun_t3rd
   dockrun_t3rd --help
   T3DOCS_DEBUG=1  dockrun_t3rd
   T3DOCS_DEBUG=1  dockrun_t3rd makehtml
   T3DOCS_DEBUG=1  dockrun_t3rd makehtml-no-cache -c make_singlehtml 1


Documentation
=============

*  `The T3DocsRenderingContainer (Draft)
   <https://docs.typo3.org/m/typo3/T3DocsRenderingContainer/draft/en-us/>`__

*  `Release notes and What's new?`
   <https://docs.typo3.org/m/typo3/T3DocsRenderingContainer/draft/en-us/Whatsnew/Index.html>`__


See also
========

See chapter
`How to render documentation
<https://docs.typo3.org/m/typo3/docs-how-to-document/master/en-us/RenderingDocs/>`_
in `Writing documentation
<https://docs.typo3.org/m/typo3/docs-how-to-document/master/en-us/>`_.


Enjoy!

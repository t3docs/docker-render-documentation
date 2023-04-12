================================
DRC - Docker Rendering Container
================================

Use this repository and :code:`docker build` to build the TYPO3 official Docker
image :code:`t3docs/render-documentation` for rendering `TYPO3 documentation
<https://docs.typo3.org/>`__. You may as well skip building and use ready
made containers from `ghcr.io <https://ghcr.io/>`__.

What for?

TYPO3 uses plain UTF-8 text files with reStructuredText (reST) markup
for documentation. Such documentation is readable by itself to some extend.
However, the `Sphinx documentation tool
<https://www.sphinx-doc.org/>`__ is used to produce the final html result.
This DRC bundles everything that's needed for generating the final
documentation. All it takes is a simple command at the command line.
However, having Docker installed is a requirement.


Characteristics
===============

:Repository:      https://github.com/t3docs/docker-render-documentation
:Branches:        "main" for image tagged "latest", "develop" for image
                  tagged "develop"
:Releases:        See `Releases <https://github.com/t3docs/docker-render-documentation/releases>`__
                  for more tags
:Version:         See `VERSION.txt <VERSION.txt>`__
:Authors:         TYPO3 Documentation Team
:Main caretaker:  Martin Bless <martin.bless@mbless.de>
:License:         MIT


Installation
============

Docker is required on your machine. You can use Linux-like systems like Mac, Linux, WSL2.

Windows with Docker installed (no WSL2) is also possible. Important: Use the older
:code:`command line` window and NOT Powershell.

At the command line::

   # Fetch the Docker image. "tag" may be "latest (default)", "develop", "dev30" or similar.
   docker pull ghcr.io/t3docs/render-documenation[:tag]

   # Attach the canonical tag "t3docs/render-documentation" to the image - without "ghcr.io/"!
   docker tag  ghcr.io/t3docs/render-documenation[:tag]  ghcr.io/t3docs/render-documenation[:tag]

   # verify the image can be run as container
   docker run --rm t3docs/render-documentation[:tag]
   docker run --rm t3docs/render-documentation[:tag] --help
   docker run --rm t3docs/render-documentation[:tag] --version
   docker run --rm t3docs/render-documentation[:tag] show-shell-commands

   # on Mac, Linux, WSL2: define helper function `dockrun_t3rd`
   eval "$(docker run --rm t3docs/render-documentation[:tag] show-shell-commands)"

   # On Windows (not WSL2) create file 'dockrun_t3rd.bat'
   # Make sure the file is somehwere on your PATH.
   docker run --rm t3docs/render-documentation[:tag] show-windows-bat > dockrun_t3rd.bat


To update to a newer container version just repeat these steps.


Usage
=====

1. Open terminal window

2. Prepare::

      # Linux-like systems (Linux, Mac, WSL2)
      # Define helper function, if it's not already in your .bashrc or .zshrc
      eval "$(docker run --rm t3docs/render-documentation[:tag] show-shell-commands)"

      # for Windows there is nothing to do. However, 'dockrun_t3rd.bat' should
      # be on your PATH.

3. Verify::

      # Verify it's working. If it runs, it's ok.
      dockrun_t3rd --help

4. Render documentation::

      # Go to the PROJECT = first = root = start (!) folder of your project.
      # The actual documentation is expected to be in PROJECT/Documentation
      cd PROJECT

      # Run the rendering
      dockrun_t3rd  makehtml

5. Find rendering results in :code:`PROJECT/Documentation-GENERATED-temp`

6. Optionally, try these examples::

      T3DOCS_DEBUG=1  dockrun_t3rd
      T3DOCS_DEBUG=1  dockrun_t3rd makehtml
      T3DOCS_DEBUG=1  dockrun_t3rd makehtml-no-cache -c make_singlehtml 1


Documentation
=============

*  `The T3DocsRenderingContainer (Draft)
   <https://docs.typo3.org/m/typo3/T3DocsRenderingContainer/draft/en-us/>`__

*  `Release notes and What's new?
   <https://docs.typo3.org/m/typo3/T3DocsRenderingContainer/draft/en-us/Whatsnew/Index.html>`__


Features
========

What markup can you use?

The DRC bundles the Sphinx tool, Sphinx extensions, a Sphinx TYPO3 theme, a toolchain and some
logic and user interface components. We are using a "stress test" demonstration manual (`GitHub repository
<https://github.com/TYPO3-Documentation/sphinx_typo3_theme_rendering_test>`__)
to test that everything works as expected.
Check the rendering result `Sphinx TYPO3 Theme Rendering Test
<https://typo3-documentation.github.io/sphinx_typo3_theme_rendering_test/>`__
of this repository to find out what markup you can use and how it will look like when rendered.


Contributing
============

Contributions are always welcome! Please use
`GitHub issues <https://github.com/t3docs/docker-render-documentation/issues>`__
or
`GitHub pull requests <https://github.com/t3docs/docker-render-documentation/pulls>`__.




Enjoy!

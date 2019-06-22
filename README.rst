===========================
t3docs/render-documentation
===========================

How to build the TYPO3 official Docker image `t3docs/render-documentation` for
rendering TYPO3 documentation.

:Repository:      https://github.com/t3docs/docker-render-documentation
:Version:         v2.2.4
:Capabilites:     html, singlehtml
:Docker image:    t3docs/render-documentation:v2.2.4
                  https://hub.docker.com/r/t3docs/render-documentation/
:Docker tags:     https://hub.docker.com/r/t3docs/render-documentation/tags/
:Documented at:   https://github.com/t3docs/t3docs-documentation
:Authors:         TYPO3 Documentation Team


Documentation
=============

The documentation for this project is maintained at Github in project
`t3docs-documentation <https://github.com/t3docs/t3docs-documentation>`__
at Github.


Release notes
=============

What has changed? See `CHANGES <CHANGES.rst>`_.


Using the image
===============

All systems
-----------

Pull and run the image to show some help::

   docker run --rm t3docs/render-documentation:v2.1.0


Linux-like systems
------------------

Define convenience function (=shell command) `dockrun_t3rd`::

   source <(docker run --rm t3docs/render-documentation:v2.1.0 show-shell-commands)

Create a project and render the documentation::

   # create directory and go there
   mkdir -p ~/HelloWorldProject
   cd ~/HelloWorldProject

   # create documentation
   echo "Hello world\!" >  README.rst
   echo "=============" >> README.rst
   echo "This is my line of documentation ..." >> README.rst

   # render the TYPO3-style documentation
   dockrun_t3rd makehtml


Building the image
==================

If your shell is BASH and you want to build your own local image tagged 'local'
run::

   OUR_IMAGE_TAG=local  ./Dockerfile.build.sh

In rare case for unknown reasons it has been observed that the build process
stalls. In that case simply try again. It is normal to see some red lines
on the console.


Contribute
==========

Please use the `issue tracker
<https://github.com/t3docs/docker-render-documentation/issues>`_
for contributing and reporting.


Finally
=======

Enjoy!

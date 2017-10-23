
===========================
docker-render-documentation
===========================

This is the official recipe to build the Docker image 't3docs/render-documentation'.

:Authors:         TYPO3 Documentation Team
:Repository:      https://github.com/t3docs/docker-render-documentation
:Docker image:    `t3docs/render-documentation <https://store.docker.com/community/images/t3docs/render-documentation>`__
:Read more:       https://docs.typo3.org/typo3cms/RenderTYPO3DocumentationGuide/UsingDocker/

.. default-role:: code

Contribute
==========

Please use the `issue tracker <https://github.com/t3docs/docker-render-documentation/issues>`__ for
contributing and reporting.


Quickstart on Linux
===================

Please confirm this is working on BSD-Linux (Mac) as well.


Prepare
-------

1. `Install Docker <https://docs.docker.com/engine/installation/>`__


2. Verify Docker is working::

      docker run --rm hello-world

   You should see::

      Hello from Docker.
      This message shows that ...


3. Download the image::

      docker pull t3docs/render-documentation

   **Note:** The first download is rather big (> 2.5 GB) as it now contains
   LaTeX files for PDF-generation. Most of it should not change often and
   needs to be downloaded only once.


4. Verify::

      docker run --rm t3docs/render-documentation

   You should see::

      For help:
         docker run --rm t3docs/render-documentation --help

5. Define some shell commands::

      # just show
      docker run --rm t3docs/render-documentation show-shell-commands

      # actually define - no blanks between '<('
      source <(docker run --rm t3docs/render-documentation show-shell-commands)
      
      # If line `source <(...)` doesn't work on your OS use these three lines
      docker run --rm t3docs/render-documentation show-shell-commands > tempfile.sh
      source tempfile.sh
      rm tempfile.sh

      # verify 'TYPO3 render documentation full'
      dockrun_t3rdf --help


Render your documentation
-------------------------

1. Get a sample project with documentation::

      # clone a starter project
      git clone https://github.com/T3DocumentationStarter/Public-Info-000 PROJECT

      # go to the root folder of the project
      cd PROJECT

2. Do the rendering::

      dockrun_t3rdf makehtml


3. Find the results::

      # html
      PROJECT/Documentation-GENERATED-temp/Index.html

      # singlehtml (all in one file)
      PROJECT/Documentation-GENERATED-temp/singlehtml/Index.html

      # build information
      PROJECT/Documentation-GENERATED-temp/_buildinfo/

      # Sphinx warnings and errors - should be empty!
      PROJECT/Documentation-GENERATED-temp/_buildinfo/warnings.txt

      # Sphinx latex files (only if existing and PDF-createn failed)
      PROJECT/Documentation-GENERATED-temp/_buildinfo/latex/


Enjoy!


Quickstart on Windows
=====================

((to be contributed))

Please contribute.


Building (for developers)
=========================

Run build:

    docker build -t t3docs/render-documentation .

In case you have an `apt-cacher <https://docs.docker.com/engine/examples/apt-cacher-ng/>`__
at hand this may be *the* way. Apt-packages are then downloaded only once and kept
to later be reused again::

    docker start my-apt-cacher
    HOSTIP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
    docker build -t t3docs/t3docs/render-documentation --build-arg http_proxy=http://${HOSTIP}:3142 .


Finally
=======

Enjoy!

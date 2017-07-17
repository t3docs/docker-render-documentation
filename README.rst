
===========================
docker-render-documentation
===========================

This is the recipe to build a Docker image.

:Authors:         TYPO3 Documentation Team
:Repository:      https://github.com/t3docs/docker-render-documentation
:Docker image:    `t3docs/render-documentation <https://store.docker.com/community/images/t3docs/renderdocumentation>`__
:Read more:       https://docs.typo3.org/typo3cms/RenderTYPO3DocumentationGuide/UsingDocker/

.. default-role:: code

Quickstart on Linux
===================

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

      # verify
      dockrun_t3rd --help


Render your documentation
-------------------------

1. Get a sample project with documentation::

      # clone a starter project
      git clone https://github.com/T3DocumentationStarter/Public-Info-000 PROJECT

      # go to the root folder of the project
      cd PROJECT

2. Start rendering::

      dockrun_t3rd makehtml

3. Find the results::

      # html
      PROJECT/Documentation-GENERATED-temp/Index.html

      # build information
      PROJECT/Documentation-GENERATED-temp/_buildinfo/

      # Sphinx warnings and errors
      PROJECT/Documentation-GENERATED-temp/_buildinfo/warnings.txt

Enjoy!


Quickstart on Windows
=====================

((to be written))

Please contribute.

Use the `issue tracker <https://github.com/t3docs/docker-render-documentation/issues>`__ for your contributions and
help other Windows users to enjoy.

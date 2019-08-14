.. include:: ../Includes.txt
.. highlight:: text


.. _quickstart:

==========
Quickstart
==========

Navigate this page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top



Requirements
============

Verify you have Docker installed::

   ➜  ~ docker --version
   Docker version 19.03.1, build 74b1e89

   ➜  ~

Go to the start folder of a project (not the project/Documentation folder)::

   cd ~/project

If you don't have a project, create a minimal one::

   mkdir ~/project
   cd ~/project
   echo 'My dummy project'  > README.rst
   echo '================' >> README.rst
   echo                    >> README.rst
   echo 'Hello world, this is my splendid documentation.' >> README.rst

For Linux or Mac: Make your life easier and define the `dockrun_t3rd`
function::

   source <(docker run --rm t3docs/render-documentation:v2.3.0-local \
            show-shell-commands)


Go to the project and run the rendering::

   cd ~/project
   dockrun_t3rd  makehtml


Without `dockrun_t3rd` the procedure would be the following. Written in a
Windows compatible style this should work on Windows as well::

   # Create result folder
   mkdir Documentation-GENERATED-temp

   # run Docker, specific form in my case
   docker \
      run --rm --user=1000:1000 \
      -v /home/marble/project:/PROJECT:ro \
      -v /home/marble/project/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0-local \
      makehtml

   # run Docker, general form for Linux and Mac
   docker \
      run --rm --user=$(id -u):$(id -g) \
      -v $(pwd):/PROJECT:ro \
      -v $(pwd)/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0-local \
      makehtml

Note that the project is mapped into the container as /RESULT in readonly mode.
The result folder ist mapped to /RESULT in readwrite mode.

For Windows: To be done. Can somebody translate the above to a Windos example?

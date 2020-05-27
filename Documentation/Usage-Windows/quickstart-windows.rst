.. include:: /Includes.rst.txt
.. _quickstart-windows:

====================
Quickstart (Windows)
====================

For Windows.

How to get TYPO3 documentation rendering going on Windows using the Docker
container.


.. contents:: This page
   :backlinks: top
   :class: compact-list
   :depth: 3
   :local:

----

Verify you have Docker installed::

   ➜  ~ docker --version
   Docker version 19.03.1, build 74b1e89

   ➜  ~


Go to a project. Go to the top folder of your project, NOT `project/Documentation`,
if you have that::

   cd ~/project


If you don't have a project, create a minimal one with just a README file::

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


If that fails, use the long version::

   # create a folder to keep things
   mkdir -p ~/.dockrun/dockrun_t3rd
   docker run --rm t3docs/render-documentation:v2.3.0 \
      show-shell-commands > mkdir -p ~/.dockrun/dockrun_t3rd/shell-commands.sh

   # define the dockrun_t3rd function
   # Add this line to your `.bashrc` or `.zshrc` or ...?
   source ~/.dockrun/dockrun_t3rd/shell-commands.sh

Go to the project and run the rendering::

   cd ~/project

   dockrun_t3rd  makehtml


((words!))

Without `dockrun_t3rd` the procedure would be the following. Written in a
Windows compatible style this will work on Windows as well::

   # Go to the project
   cd ~/project

   # Create result folder
   mkdir Documentation-GENERATED-temp

   # Run Docker like this
   docker \
      run --rm --user=1000:1000 \
      -v /home/marble/project:/PROJECT:ro \
      -v /home/marble/project/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0-local \
      makehtml

In general the above would be written as::

   # Go to the project
   cd ~/project

   # Create result folder
   mkdir Documentation-GENERATED-temp

   # run Docker, general form for Linux and Mac
   docker \
      run --rm --user=$(id -u):$(id -g) \
      -v $(pwd):/PROJECT:ro \
      -v $(pwd)/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0-local \
      makehtml

Note that the project is mapped into the container as /RESULT in readonly mode.
The result folder ist mapped to /RESULT in readwrite mode. `--rm` means that
the container is to be removed right after it has been run. This will not
affect the downloaded docker image. With `--user=` we make sure that the
created output files do belong to the actual user and not to the super user.

For Windows: To be done. Can somebody translate the above to a Windos example?

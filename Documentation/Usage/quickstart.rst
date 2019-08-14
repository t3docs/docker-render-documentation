.. include:: ../Includes.txt
.. highlight:: text


.. _quickstart:

==========
Quickstart
==========

Verify you have Docker installed::

   ➜  ~ docker --version
   Docker version 19.03.1, build 74b1e89

   ➜  ~


If you don't have a project, create a minimal one with just a README file in a
new folder::

   mkdir ~/project

   cd ~/project

   echo 'My dummy project'  > README.rst
   echo '================' >> README.rst
   echo                    >> README.rst
   echo 'Hello world, this is my splendid documentation.' >> README.rst


Go to the start folder of your project - NOT the project/Documentation
subfolder, if you have that::

   cd ~/project


For Linux or Mac: Make your life easier and define the `dockrun_t3rd`
function::

   source <(docker run --rm t3docs/render-documentation:v2.3.0-local \
            show-shell-commands)


Go to the project and run the rendering::

   cd ~/project

   dockrun_t3rd  makehtml


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

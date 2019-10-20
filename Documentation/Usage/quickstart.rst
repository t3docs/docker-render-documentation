.. include:: ../Includes.rst.txt


.. _quickstart:

==========
Quickstart
==========

For Linux and Mac.

Verify you have Docker installed::

   ➜  ~ docker --version
   Docker version 19.03.4, build 9013bf583a

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

Using 'dockrun_t3rd', the handy helper function
===============================================

Create a place to store a shell file to. We recommend
`.dockrun/dockrun_t3rd` in your home directory. Create a `shell-commands.sh`
file there that can afterwards be used to define a helper function. To do that
import that file in a shell session by means of the `source` command.
To always do that automatically, add an appropriate line to your BASH
or ZSH startup file. How it can be done::

   # create a folder to keep things
   mkdir -p ~/.dockrun/dockrun_t3rd
   
   # create the file with shell commands there
   docker run --rm t3docs/render-documentation:v2.3.0 \
      show-shell-commands   > ~/.dockrun/dockrun_t3rd/shell-commands.sh

   # import the commands in a shell session
   source ~/.dockrun/dockrun_t3rd/shell-commands.sh
   
   # optional: add the command to your startup file
   echo 'source ~/.dockrun/dockrun_t3rd/shell-commands.sh' >> ~/.bashrc
   echo 'source ~/.dockrun/dockrun_t3rd/shell-commands.sh' >> ~/.zshrc


Tip: On most Linuxes you can source the shell commands directly
without and intermediate file like so. This has been reported to
not work for Macs::

   source <(docker run --rm t3docs/render-documentation:v2.3.0-local \
            show-shell-commands)



Go to the project and run the rendering::

   cd ~/project

   dockrun_t3rd  makehtml
   # or
   dockrun_t3rd  makeall


Using plain Docker commands
===========================

You need to replace the project path `/home/marble/project`
with the real absolute path of your project::

   # Go to the project
   cd ~/project

   # Create result folder
   mkdir Documentation-GENERATED-temp

   # Run the image
   docker \
      run --rm --user=$(id -u):$(id -g) \
      -v /home/marble/project:/PROJECT:ro \
      -v /home/marble/project/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0 \
      makehtml

.. attention::

   Make sure you map PROJECT in readonly mode. This will protect
   your files from being damaged in case something is going wrong
   inside the container.

Note that the project is mapped into the container as /PROJECT:ro
which means readonly mode.
The result folder is mapped to /RESULT in readwrite mode. `--rm` means that
the container is to be removed right after it has been run. This will not
affect the downloaded docker image. With `--user=` we make sure that the
created output files do belong to the actual user and not to the super user.

.. include:: /Includes.rst.txt


.. _quickstart:

==========
Quickstart
==========

This page is for Linux and Mac.

Preparations
============

Verify you have Docker installed::

   ➜  ~ docker --version
   Docker version 19.03.4, build 9013bf583a

   ➜  ~


Go to a project. Go to the top folder :file:`project/`
of your project, DO NOT go to :file:`project/Documentation/`,
if you have that::

   cd ~/project


You don't have a project at hand? Create a minimal one with just one
file named :file:`README.rst`::

   # create project folder
   mkdir ~/project

   # go to there
   cd ~/project

   # Type a headline and a sentence to that file
   echo 'My dummy project'  > README.rst
   echo '================' >> README.rst
   echo                    >> README.rst
   echo 'Hello world, this is my splendid documentation.' >> README.rst


Build HTML using 'dockrun_t3rd'
===============================

'dockrun_t3rd' is just a handy helper function to run the
Docker command for t3rd, that is: TYPO3 render documentation.
This function can make your life much easier, so please give it
a try!

1. Create a place to store a shell file to. We recommend
   :file:`.dockrun/dockrun_t3rd` in your home directory. Create a :file:`shell-commands.sh`
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


   *Tip:* On most Linuxes you can source the shell commands directly
   without and intermediate file like so. This has been reported to
   not work on Macs::

      source <(docker run --rm t3docs/render-documentation:v2.3.0-local show-shell-commands)


2. Go to the project and run the rendering::

      cd ~/project

      dockrun_t3rd  makehtml

      # or

      dockrun_t3rd  makeall

   Ask the container for help::

      ➜  ~ dockrun_t3rd

      t3rd - TYPO3 render documentation (v2.4.0-dev)
      For help:
         docker run --rm t3docs/render-documentation:v2.4.0-dev --help
         dockrun_t3rd --help

      ... did you mean 'dockrun_t3rd makehtml'?

      See manual (draft) at
      https://docs.typo3.org/m/typo3/t3docs-docker-render-documentation/draft/en-us/


      ➜  ~ dockrun_t3rd --help
         # lots of lines ...


      ➜  ~



Build HTML with plain Docker commands
=====================================

*Attention:* You need to replace the project path :file:`/home/marble/project` with
whatever is valid in your case::

   # Go to the project
   cd ~/project

   # Create result folder
   mkdir Documentation-GENERATED-temp

   # Run the rendering
   docker \
      run --rm --user=$(id -u):$(id -g) \
      -v /home/marble/project:/PROJECT:ro \
      -v /home/marble/project/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0 \
      makehtml

.. attention::

   Make sure you map PROJECT in readonly mode. This will protect your files
   from being damaged in case something is going wrong with the complex
   machinery inside the container. It shouldn't happen. But who knows?

About the Docker command: Note that the project is mapped as /PROJECT:ro which
means **readonly mode**. Results are created in /RESULT, so this folder is
mapped in normal readwrite mode. `--rm` means that the container is to be
removed right after it has been run. Otherwise a useless copy of the image
would be left on disk each time the command is run. The pulled Docker image is
not affected by the `--rm` option. With `--user=` we make sure that the created
output files do belong to the actual user and not to the super user.

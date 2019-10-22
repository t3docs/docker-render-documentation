.. include:: Includes.txt
.. index:: Glossary
.. _Glossary:

========
Glossary
========

.. glossary::

   Docker
      "Docker provides a way to run applications securely isolated in a
      container, packaged with all its dependencies and libraries."

      Installation: Get Docker from https://docs.docker.com/install/

   Docutils
      ...

   dockrun
      Docker commands can be very long and complicated. To make things easier
      we sometimes use helper scripts like "t3rd" (T3 render documentation.
      We allways prefix those names with `dockrun_` to make explicite what
      the scripts are doing in the end. There may be :file:`dockrun_XXX.bat`
      for Windows and :file:`dockrun_XXX.sh` - or so - for other systems.

   jobfile
      This is usually a JSON file named :file:`jobfile.json`. The idea is to
      make all possible settings and options configurable in that one single
      file. It can have any name. That file is in the hands of the system
      administrator or operator.

   RenderDocumentation
      This is the specific :term:`toolchain` that we are using.

   ReST
      :ref:`reStructuredText <about-docutils>` is the markup language used.

   TCT
      This is the toolchain runner that we are using. The original name was
      "tool chain tool", hence the abbreviation TCT.

   toolchain
      This is the name of a folder that resides in the Toolchains_Starting
      folder. The toolchain is an arbitrary structure of files and subfolders
      holding executables that have a name starting with `run_`.


.. tip:  use the 'term' role to reference terms, like :term:`TCT`

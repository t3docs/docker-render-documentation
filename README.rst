
===========================
docker-render-documentation
===========================

.. default-role:: code
.. highlight:: shell

This is the official recipe to build the Docker image
't3docs/render-documentation'.

:Authors:         TYPO3 Documentation Team
:Repository:      https://github.com/t3docs/docker-render-documentation
:Docker image:    t3docs/render-documentation,
                  https://store.docker.com/community/images/t3docs/render-documentation,
                  https://hub.docker.com/r/t3docs/render-documentation/
:Read more:       https://docs.typo3.org/typo3cms/RenderTYPO3DocumentationGuide/UsingDocker/
:See also:        Toolchain 'RenderDocumentation'
                  https://github.com/marble/Toolchain_RenderDocumentation
:Date:            2018-04-29
:Version:         1.6.5


Contribute
==========

Please use the `issue tracker
<https://github.com/t3docs/docker-render-documentation/issues>`__ for
contributing and reporting.


Quickstart on Linux
===================

Prepare Docker
--------------

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

      # In case line `source <(...)` doesn't work on your OS use these three
        lines::

           docker run --rm t3docs/render-documentation show-shell-commands > tempfile.sh
           source tempfile.sh
           rm tempfile.sh

      # Verify there now is a command to 'TYPO3 render documentation full'::

           dockrun_t3rdf --help


Render your documentation
-------------------------

1. Go to the **start folder** of your PROJECT. It should have a subfolder
   PROJECT/Documentation.

   You can use this `starter project
   <https://github.com/T3DocumentationStarter/Public-Info-000/archive/master.zip>`__
   as an example::

      # download
      wget https://github.com/T3DocumentationStarter/Public-Info-000/archive/master.zip

      # unpack
      unzip  Public-Info-000-master.zip

      # DO NOT go to the subfolder Public-Info-000-master/Documentation !!!

      # go to the **start folder** of the PROJECT
      cd Public-Info-000-master


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

      # Sphinx latex files (only if existing and PDF-creation failed)
      PROJECT/Documentation-GENERATED-temp/_buildinfo/latex/



Quickstart on Windows
=====================

((to be contributed))

Please contribute.

The Docker image will run just fine on Windows and do the all the rendering.
What's missing is the text in this read me file and appropriate helper
functions.


Advanced
========

Run control
-----------
Do not generate 'singlehtml', 'latex' and 'pdf' off::

   dockrun_t3rdf makehtml \
         -c make_singlehtml 0 \
         -c make_latex 0 \

Turn 'singlehtml', 'latex' and 'pdf' on::

   dockrun_t3rdf makehtml \
         -c make_singlehtml 1 \
         -c make_latex 1 \
         -c make_pdf

Specifying folders
------------------
Read through the output of `docker run --rm
t3docs/render-documentation show-shell-commands` for more information.

*Note:* Use absolute paths. Do not use '/' at the end.

If your source project is not in the current directory you can specify that
by setting the environment variable `T3DOCS_PROJECT`::

   T3DOCS_PROJECT=/abs/path/to/project
   t3dockrun_t3rdf makehtml

Specify a result folder if you don't want to have the result in the current
directory. The final output folder
`$T3DOCS_RESULT/Documentation-GENERATED-temp` will be created::

   T3DOCS_RESULT=/abs/path/to/result
   t3dockrun_t3rdf makehtml

Specify a path to a temp folder if you want to expose all those many
intermediate temp files for inspection. `$T3DOCS_RESULT/tmp-GENERATED-temp`
will be used::

   T3DOCS_TMP=/tmp
   t3dockrun_t3rdf makehtml



Finally
=======

Enjoy!

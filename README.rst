
===========================
docker-render-documentation
===========================

.. default-role:: code
.. highlight:: shell

This is the official recipe to build the Docker image
't3docs/render-documentation'.

:Authors:         TYPO3 Documentation Team
:Repository:      https://github.com/t3docs/docker-render-documentation
:Branch:          master-debian-html
:Docker image:    t3docs/render-documentation,
                  https://hub.docker.com/r/t3docs/render-documentation/
:Docker tags:     https://hub.docker.com/r/t3docs/render-documentation/tags/
:Documentation:   Is being moved to https://github.com/t3docs/t3docs-documentation
                  and maintained separately
:Read more:       https://docs.typo3.org/typo3cms/RenderTYPO3DocumentationGuide/UsingDocker/
:See also:        Toolchain 'RenderDocumentation'
                  https://github.com/marble/Toolchain_RenderDocumentation
:Date:            2018-10-26
:Version:         Docker image version 'latest'='v1.6.11-html', from
                  repository branch 'master-debian-html'
:Capabilites:     html, singlehtml, package


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

      docker pull t3docs/render-documentation:v1.6.11-html

4. Verify::

      docker run --rm t3docs/render-documentation:v1.6.11-html

   You should see::

      t3rdh - TYPO3 render documentation full (v1.6.11-html)
      For help:
         docker run --rm t3docs/render-documentation:v1.6.11-html --help
         dockrun_t3rdh --help

      ... did you mean 'dockrun_t3rdh makehtml'?

5. Define some shell commands::

      # just show
      docker run --rm t3docs/render-documentation:v1.6.11-html show-shell-commands

      # actually define - no blanks between '<('
      source <(docker run --rm t3docs/render-documentation:v1.6.11-html show-shell-commands)

      # In case line `source <(...)` doesn't work on your OS use these three
        lines::

           docker run --rm t3docs/render-documentation:v1.6.11-html show-shell-commands > tempfile.sh
           source tempfile.sh
           rm tempfile.sh

      # Verify there now is a command to 'TYPO3 render documentation full'::

           dockrun_t3rdh --help


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

      dockrun_t3rdh makehtml           # only html
      dockrun_t3rdh makeall            # html, singlehtml, package

3. Find the results::

      # html
      PROJECT/Documentation-GENERATED-temp/Result/Project/0.0.0/Index.html

      # singlehtml (all in one file)
      PROJECT/Documentation-GENERATED-temp/Result/Project/0.0.0/singlehtml/Index.html

      # build information
      PROJECT/Documentation-GENERATED-temp/Result/Project/0.0.0/_buildinfo/

      # Sphinx warnings and errors - should be empty!
      PROJECT/Documentation-GENERATED-temp/Result/Project/0.0.0/_buildinfo/warnings.txt


Quickstart on Windows
=====================

Please contribute.

The Docker image will run just fine on Windows and do the all the rendering.
What's missing is the text in this README file and the corresponding helper
functions.


Advanced
========

Run control
-----------
Select just HTML rendering and add more selectively::

   dockrun_t3rdh makehtml \                 # html is always being built
         -c make_singlehtml 1 \             # enable singlehtml
         -c make_package    1               # enable standalone package

Or select ALL and turn off what you don't need::

   dockrun_t3rdh makeall \                  # html is always being built
         -c make_singlehtml 0 \             # disable singlehtml
         -c make_package 0                  # disable standalone package

Specifying folders
------------------
Read through the output of `docker run --rm
t3docs/render-documentation show-shell-commands` to learn about the details.

**ATTENTION:** Use absolute paths. Do not use '/' at the end.

You can render a project that's located somewhere else. Set the environment
variable `T3DOCS_PROJECT` accordingly::

   T3DOCS_PROJECT=/abs/path/to/project
   dockrun_t3rdh makehtml

or::

   T3DOCS_PROJECT=/abs/path/to/project  dockrun_t3rdh makehtml

Specify a result folder to send the result somewhere else. The final output
folder `$T3DOCS_RESULT/Documentation-GENERATED-temp` will be created::

   T3DOCS_RESULT=/abs/path/to/result
   dockrun_t3rdh makehtml

Specify a path to a temp folder if you want to expose all those many
intermediate temp files for inspection. `$T3DOCS_RESULT/tmp-GENERATED-temp`
will be used::

   T3DOCS_TMP=/tmp
   dockrun_t3rdh makehtml


Rename to default tag 'latest'
------------------------------
If you omit the tag it defaults to 'latest'. So you may want to rename the
downloaded image to 'latest' if what you downloaded was not 'latest'::

   # remove
   docker rmi t3docs/render-documentation:latest
   # pull
   docker pull t3docs/render-documentation:v1.6.11-html
   # rename
   docker tag t3docs/render-documentation:v1.6.11-html \
              t3docs/render-documentation:latest
   # use the generic name without tag, for example in ~/.bashrc
   source <(docker run --rm t3docs/render-documentation show-shell-commands)


Caching
=======

Caching information will be generated automatically and stored in
`$T3DOCS_RESULT/Cache`. Simply leave that folder untouched to make use of
the caching mechanism. With caching, for example, a `makehtml` for the TYPO3
core ChangeLog may take only 15 seconds instead of 20 minutes.

The cache information is built while `html` processing. Other writers like
`singlehtml` make use of that same caching information and are working rather
fast. Therefore in general it should not be necessary to turn them off.


Caching for ./Documentation files of a repository
=================================================

The caching mechanism considers a file to be changed when the file modification
time (mtime) has changed. Revision control systems like Git usually don't
preserve file modification times.

**Tip:** You may want to look at the https://github.com/MestreLion/git-tools
Add the script `git-restore-mtime` to your path. Then, for example, do::

   # go to repo
   cd ~Repositories/git.typo3.org/Packages/TYPO3.CMS.git
   git-restore-mtime

It only takes a few seconds to set the mtime of more than 12.500 files to a
constant and meaningful value. Each file's mtime will be set to the value of
the most recent commit that changed that file.

Repeat the `git-restore-mtime` procedure after Git operations like branch
switches and checking out files.

NEW since version version 1.6.10: If you start the container via the `dockrun_...`
command `git-restore-mtime` will be run automatically if it is an executable
and can be found.


What to ignore in GIT
=====================

**Advice:** Add a line to your *global* GIT ignore file::

   echo "*GENERATED*" >>~/.gitignore_global


Finally
=======

Enjoy!

.. include:: /Includes.rst.txt
.. highlight:: text


.. _dockrun_t3rd-commands:

=======================
Using 'dockrun_t3rd'
=======================

Collecting examples.

**On this page:**

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top



dockrun_t3rd
============

*Note:* Replace 'v2.3.0-local' in the following with whatever you have.

The `dockrun_t3rd` command is available for Linux and Mac. It is a function
defined in the shell. To define it run::

   source <(docker run --rm t3docs/render-documentation:v2.3.0-local \
            show-shell-commands)

If that doesn't work use the long form::

   docker run --rm \
      t3docs/render-documentation:v2.3.0-local >~/.docker-shell-commands.sh
   source ~/.docker-shell-commands.sh

This should show::

   This function is now defined FOR THIS terminal window:
    dockrun_t3rd

Consider adding a line to the startup file of your shell. Common ones are
:file:`~/.bashrc` or :file:`~/.zshrc`::

   source ~/.docker-shell-commands.sh

Afterwards the `dockrun_t3rd` should automatically be  available in every
shell you open.


It is a convenience function with this functionality: ...


Without arguments
-----------------

Show minimal help::

   ➜  ~ dockrun_t3rd
   t3rd - TYPO3 render documentation (v2.3.0-local)
   For help:
      docker run --rm t3docs/render-documentation:v2.3.0-local --help
      dockrun_t3rd --help

   ... did you mean 'dockrun_t3rd makehtml'?

   ➜  ~


--help
------


Show help synopsis::

   ➜  ~ dockrun_t3rd --help

   Usage:
       Prepare:
           Define function 'dockrun_t3rd' on the commandline of your system:
               source <(docker run --rm t3docs/render-documentation:v2.4.0-dev show-shell-commands)
           Inspect function:
               declare -f dockrun_t3rd
       Usage:
           dockrun_t3rd [ARGS]
               ARGUMENT             DESCRIPTION
               --help               Show this menu
               --version            Show buildinfo.txt of this container
               bashcmd              Run a bash command in the container
               export-ALL           Copy /ALL to /RESULT/ALL-exported
               makeall              Run for production - create ALL
               makeall-no-cache     like makeall, but remove previous cache
               makehtml             Run for production - create only HTML
               makehtml-no-cache    like makehtml, but remove previous cache
               tct                  Run TCT, the toolchain runner
               show-shell-commands  Show useful shell commands and functions
               show-howto           Show howto (not totally up to date)
               show-faq             Show questions and answers (not totally up to date)
               /bin/bash            Enter the container's Bash shell as superuser
               /usr/bin/bash        Enter the container's Bash shell as normal user

       Examples:
           dockrun_t3rd
           dockrun_t3rd --help
           dockrun_t3rd export-ALL
           dockrun_t3rd makeall-no-cache
           dockrun_t3rd makehtml
           dockrun_t3rd /bin/bash
           dockrun_t3rd /user/bin/bash
           dockrun_t3rd bashcmd 'ls -la /ALL'

   End of usage.

   ➜  ~


--version
---------

::

   ➜  ~ dockrun_t3rd --version
   Versions used for v2.3.0:
   Sphinx theme        :: t3SphinxThemeRtd    :: 3.6.16 :: mtime:1530870718
   Toolchain           :: RenderDocumentation :: 2.7.0
   Toolchain tool      :: TCT                 :: 1.0.0
   TYPO3-Documentation :: typo3.latex         :: v1.1.0
   TypoScript lexer    :: typoscript.py       :: v2.2.4

   DEBIAN_FRONTEND     :: noninteractive
   DOCKRUN_PREFIX      :: dockrun_
   OUR_IMAGE           :: t3docs/render-documentation:v2.3.0-local
   OUR_IMAGE_SHORT     :: t3rd
   OUR_IMAGE_SLOGAN    :: t3rd - TYPO3 render documentation
   OUR_IMAGE_TAG       :: v2.3.0-local
   OUR_IMAGE_VERSION   :: v2.3.0
   TOOLCHAIN_TOOL_URL  :: https://github.com/marble/TCT/archive/develop.zip
   TOOLCHAIN_URL       :: https://github.com/marble/Toolchain_RenderDocumentation/archive/develop.zip

   ➜  ~


bashcmd
-------

Run a shell command in the container. The Python virtual environment is
activated::

   ➜  ~ dockrun_t3rd bashcmd python --version
   Python 2.7.15+

   Final exit status: 0 (completed)

   ➜  ~


::

   ➜  ~ dockrun_t3rd bashcmd pwd
   /ALL/venv

   Final exit status: 0 (completed)

   ➜  ~


::

   ➜  ~ dockrun_t3rd bashcmd ls /ALL
   Downloads
   Makedir
   Menu
   Toolchains
   global-gitconfig.cfg
   userhome
   venv

   Final exit status: 0 (completed)

   ➜  ~


makeall
-------

We assume a project at /home/marble/project and cd into that project. A
minimal project can be created like this::

   mkdir ~/project
   cd ~/project
   echo 'My dummy project'  > README.rst
   echo '================' >> README.rst
   echo                    >> README.rst
   echo 'Hello world, this is my splendid documentation.' >> README.rst

Build everything from that documentation::

   dockrun_t3rd makeall

From :file:`Documentation-GENERATED-temp/last-docker-run-command-GENERATED.sh.txt`
you can tell that this was the actual docker command::

   docker run --rm --user=1000:1000 \
      -v /home/marble/project:/PROJECT:ro \
      -v /home/marble/project/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0-local \
      makeall

`makeall` stands for make_html + make_singlehtml + make_latex + make_pdf +
make_package. If the container is not able to build a specific output this
won't happen, but you can still select it.Building of html is always done, this can't be
deselected.

To not build a package you can deselect them like so::

   dockrun_t3rd  makeall  -c make_latex 0  -c make_package 0

The intermediate output of Sphinx will be cached in the result directory as
Documentation-GENERATED-temp/Cache. It will be reused on the next run and can
speed up things considerably. If you make structural changes to you manual,
for example by adding new pages, the menus in the output may not be consistent
as only updated files are written. Better use `makeall-no-cache` in such
situations.


The result
~~~~~~~~~~

::

   ➜  project dockrun_t3rd makeall

   ==================================================
      10-Toolchain-actions/run_01-Start-with-everything.py
      exitcode:   0            38 ms



   ... much more ...



   ==================================================
      60-Publish/run_14-Reveal-exitcodes-and-milestones.py
      exitcode:   0            40 ms

   ==================================================
      90-Finish/run_10-Say-goodbye.py

   project : 0.0.0 : Makedir
      makedir /ALL/Makedir
      2019-08-14 15:50:12 861067,  took: 7.77 seconds,  toolchain: RenderDocumentation
      REBUILD_NEEDED because of change,  age 434943.8 of 168.0 hours,  18122.7 of 7.0 days
      OK: buildinfo, html, singlehtml

      exitcode:   0            39 ms

   ==================================================
      90-Finish/run_20-Remove-lock.py
      exitcode:   0            38 ms

   We saw these exitcodes (code, count):
   {
     "0": 80
   }

   Final exit status: 0 (completed)

   Find the results:
     ./Documentation-GENERATED-temp/Result/project/0.0.0/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/singlehtml/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo
     ./Documentation-GENERATED-temp/Result/latex/run-make.sh

   Congratulations:
       There are no Sphinx warnings!

   ➜  ~




makeall-no-cache
----------------

This command will remove the cache of a previous prior to running `makeall`. In
effect this means that a complete rebuild is done.


makehtml
--------

We assume a project at /home/marble/project and cd into that project::

   mkdir ~/project
   cd ~/project
   echo A dummy documentation  > README.rst
   echo ===================== >> README.rst
   echo                       >> README.rst
   echo Hello world, this is my infamous documentation. > README.rst

Build html from that documentation::

   dockrun_t3rd makeall


From :file:`Documentation-GENERATED-temp/last-docker-run-command-GENERATED.sh.txt`
you can tell that this was the actual docker command::

   docker run --rm --user=1000:1000 \
      -v /home/marble/project:/PROJECT:ro \
      -v /home/marble/project/Documentation-GENERATED-temp:/RESULT \
      t3docs/render-documentation:v2.3.0-local \
      makehtml

`makehtml` stands for just building html. You can select more like so::

   dockrun_t3rd  makehtml  -c make_singlehtml 1  -c make_latex 1  \
                           -c make_package 1  -c make_pdf 1

At the moment the container cannot build a pdf or a package. In case you
selected them these steps are simply skipped.

The intermediate output of Sphinx will be cached in the result directory as
Documentation-GENERATED-temp/Cache. It will be reused on the next run and can
speed up things considerably. If you make structural changes to you manual,
for example by adding new pages, the menus in the output may not be consistent
as only updated files are written. Better use `makehtml-no-cache` in such
situations.




The result
~~~~~~~~~~

::

   ➜  project dockrun_t3rd makehtml

   ==================================================
      10-Toolchain-actions/run_01-Start-with-everything.py
      exitcode:   0            40 ms



   ... much more...



   ==================================================
      60-Publish/run_14-Reveal-exitcodes-and-milestones.py
      exitcode:   0            42 ms

   ==================================================
      90-Finish/run_10-Say-goodbye.py

   project : 0.0.0 : Makedir
      makedir /ALL/Makedir
      2019-08-14 15:53:10 532093,  took: 6.39 seconds,  toolchain: RenderDocumentation
      REBUILD_NEEDED because of change,  age 434943.9 of 168.0 hours,  18122.7 of 7.0 days
      OK: buildinfo, html

      exitcode:   0            43 ms

   ==================================================
      90-Finish/run_20-Remove-lock.py
      exitcode:   0            39 ms

   We saw these exitcodes (code, count):
   {
     "0": 80
   }

   Final exit status: 0 (completed)

   Find the results:
     ./Documentation-GENERATED-temp/Result/project/0.0.0/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo
     ./Documentation-GENERATED-temp/Result/latex/run-make.sh

   Congratulations:
       There are no Sphinx warnings!


   ➜  ~


Plus singlehtml
~~~~~~~~~~~~~~~

::

   ➜  project dockrun_t3rd  makehtml  -c make_singlehtml 1

   ==================================================
      10-Toolchain-actions/run_01-Start-with-everything.py
      exitcode:   0            37 ms



   ... much more ...



   Find the results:
     ./Documentation-GENERATED-temp/Result/project/0.0.0/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/singlehtml/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo
     ./Documentation-GENERATED-temp/Result/latex/run-make.sh

   Congratulations:
       There are no Sphinx warnings!

   ➜  ~


makehtml-no-cache
-----------------

This command will remove the cache of a previous prior to running `makeall`. In
effect this means that a complete rebuild is done.



tct
---

To be explained later.

TCT is the "Tool Chain Tool", a toolchain runner. TCT is a world of its own::

   ➜  project dockrun_t3rd tct
   Usage: tct [OPTIONS] COMMAND [ARGS]...

     TCT, the toolchain tool, runs all tools of a folder and its subfolders.

     It travels the folder in alphabetical order and topdown. A tool is an
     executable file of any kind that has a name starting with 'run_'. Files
     are run first followed by subfolders. If a tool fails (exitcode != 0)
     processing stops for the rest of that folder and continues with the next.
     An exitcode >= 90 will stop all further processing of the toolchain.

     Use --help with the subcommands.

   Options:
     --toolchains-home PATH         Root folder holding toolchains
     --temp-home PATH               Root folder for tempfiles
     -c, --config KEY VALUE         Define or override config key-value pair
                                    (repeatable, passed in FACTS to the
                                    toolchain)
     -v, --verbose                  Enable verbose mode.
     --cfg-file PATH                Read all configuration from this file only.
                                    Don't use other 'tctconfig.cfg' files.
     --active-section SECTION_NAME  Specifies which section of the cfg-file is to
                                    be used.
     --version                      Show the version and exit.
     --help                         Show this message and exit.

   Commands:
     clean   Clean the temp folder.
     config  List and get cfg data.
     list    List available toolchains.
     run     Run a toolchain.

   ➜  ~


show-shell-commands
-------------------

::

   ➜  project dockrun_t3rd show-shell-commands

   # NOTE
   # You can 'source' this file directly into the shell at your command line with:
   #     source <(docker run --rm t3docs/render-documentation:v2.3.0-local show-shell-commands)
   # ATTENTION:
   #     No whitespace between '<('

   # the usual worker command like 'dockrun_t3rd'
   function dockrun_t3rd () {



   # ... much more ...



   if [[ "$DRY_RUN" = "0" ]]; then
      eval "$cmd"
   fi
   }

   echo "This function is now defined FOR THIS terminal window:"
   echo "    dockrun_t3rd"

   ➜  ~


The purpose of this command is ...


/bin/bash
---------

Open a BASH shell inside the container AS ROOT USER::

   ➜  project dockrun_t3rd /bin/bash
   (venv) root@a97a070cface:/ALL/venv# ls
   Pipfile  Pipfile.lock  Pipfile.lock.DISABLED  info.txt	tctconfig.cfg
   (venv) root@a97a070cface:/ALL/venv# exit

   ➜  ~

This is a shortcut for::

   docker run --rm --entrypoint /bin/bash -it \
   -v /home/marble/project:/PROJECT:ro \
   -v /home/marble/project/Documentation-GENERATED-temp:/RESULT \
   t3docs/render-documentation:v2.3.0-local


show-howto
----------

The idea is to show some how to information right on the command line.

ToDo: Make `show-howto` up to date

::

   ➜  project dockrun_t3rd show-howto
   /ALL/Menu/show-howto.sh: line 10: devdockrun_t3rd: command not found
   /ALL/Menu/show-howto.sh: line 10: devdockbash_t3rd: command not found
   ==================================================
   Howto
   --------------------------------------------------

   Experts: Quickstart for the impatient
   =====================================

   ➜  ~


show-faq
--------

Same idea like `show-howto`.

::

   ...



export-ALL
----------

Within the container there is an /ALL folder that contains all the interesting
stuff that has been put there at build time. If you want to export that
folder to your local machine for inspection you can use this convenience
command::

   ➜  project dockrun_t3rd export-ALL
   The export will go to:
      /home/marble/project/Documentation-GENERATED-temp/ALL-exported

   ➜  ~


The result
~~~~~~~~~~

::

   ➜  project tree
   .
   ├── Documentation-GENERATED-temp
   │   ├── ALL-exported
   │   │   ├── Downloads
   │   │   │   ├── buildinfo.txt
   │   │   │   ├── envvars.sh
   │   │   │   └── texmf_typo3
   │   │   │       ├── fonts
   │   │   │       │   ├── map
   │   │   │       │   │   └── dvips
   │   │   │       │   │       └── share
   │   │   │       │   │           └── share.map
   │   │   │       │   ├── tfm
   │   │   │       │   │   └── typo3
   │   │   │       │   │       └── share
   │   │   │       │   │           ├── typo3shareb8t.tfm
   │   │   │       │   │           ├── typo3sharebi8t.tfm
   │   │   │       │   │           ├── typo3sharebo8t.tfm
   │   │   │       │   │           ├── typo3sharer8t.tfm
   │   │   │       │   │           ├── typo3shareri8t.tfm
   │   │   │       │   │           └── typo3sharero8t.tfm
   │   │   │       │   └── truetype
   │   │   │       │       └── typo3
   │   │   │       │           └── share
   │   │   │       │               ├── typo3sharebi.ttf
   │   │   │       │               ├── typo3sharebo.ttf
   │   │   │       │               ├── typo3shareb.ttf
   │   │   │       │               ├── typo3shareri.ttf
   │   │   │       │               ├── typo3sharero.ttf
   │   │   │       │               └── typo3sharer.ttf
   │   │   │       ├── README.rst
   │   │   │       ├── tex
   │   │   │       │   └── latex
   │   │   │       │       └── typo3
   │   │   │       │           └── share
   │   │   │       │               └── t1typo3share.fd
   │   │   │       ├── typo3_logo_color.png
   │   │   │       └── typo3.sty
   │   │   ├── global-gitconfig.cfg
   │   │   ├── Makedir
   │   │   │   ├── buildsettings.sh
   │   │   │   ├── conf-2017-09.py
   │   │   │   ├── conf.py
   │   │   │   ├── docutils.conf
   │   │   │   ├── _htaccess
   │   │   │   ├── _info.txt
   │   │   │   └── Overrides.cfg
   │   │   ├── Menu
   │   │   │   ├── mainmenu.sh
   │   │   │   ├── show-faq.sh
   │   │   │   ├── show-howto.sh
   │   │   │   └── show-shell-commands.sh
   │   │   ├── Toolchains

      ... much more ...

   │   │   │       ├── 60-Publish
   │   │   │       │   ├── combine_packages_xml.py
   │   │   │       │   ├── deliver.py
   │   │   │       │   ├── remote-symlink.sh
   │   │   │       │   ├── run_10-Create-publish-params-json.py
   │   │   │       │   └── run_14-Reveal-exitcodes-and-milestones.py
   │   │   │       ├── 90-Finish
   │   │   │       │   ├── run_10-Say-goodbye.py
   │   │   │       │   └── run_20-Remove-lock.py
   │   │   │       ├── CHANGES.rst
   │   │   │       ├── LICENSE
   │   │   │       ├── README.rst
   │   │   │       └── VERSION.txt
   │   │   ├── userhome
   │   │   └── venv
   │   │       ├── info.txt
   │   │       ├── Pipfile
   │   │       ├── Pipfile.lock
   │   │       ├── Pipfile.lock.DISABLED
   │   │       └── tctconfig.cfg
   │   └── last-docker-run-command-GENERATED.sh.txt
   └── README.rst

   75 directories, 163 files

   ➜  ~

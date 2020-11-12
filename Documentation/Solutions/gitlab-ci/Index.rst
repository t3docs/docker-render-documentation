.. include:: /Includes.rst.txt
.. index:: Gitlab CI
.. _Render_with_Gitlab_CI:

=====================
Render with Gitlab CI
=====================

.. contents:: This page
   :backlinks: top
   :local:


Downloads
=========

Example-1.gitlab-ci.yml
-----------------------

Download :download:`Example-1.gitlab-ci.yml <files/Example-1.gitlab-ci.yml>`

File content:

.. literalinclude:: files/Example-1.gitlab-ci.yml
   :language: yaml



Requirements
============

Make sure you have a running Gitlab CI pipeline and a runner is assigned to
your project.


Basic Configuration
===================

This basic configuration should cover the needs of most users as it will expose
the content to the public folder. If you already have pages configured, you'll
just need this.

.. code-block:: yaml

   pages:
     stage: test
     image:
       name: t3docs/render-documentation:develop
       entrypoint: [""]
     script:
       # cleanup
       - rm -rf $CI_PROJECT_DIR/public
       - mkdir -p $CI_PROJECT_DIR/public
       - mkdir -p /RESULT
       - rm -rf /PROJECT
       - ln -s $CI_PROJECT_DIR /PROJECT
       # switch to venv to ensure environment fits
       - cd /ALL/venv/
       # execute
       - /ALL/Menu/mainmenu.sh makeall -c jobfile /$CI_PROJECT_DIR/Documentation/jobfile.json
       # publish result
       - cp -r /RESULT/Result/project/0.0.0/* $CI_PROJECT_DIR/public
       # fix problem with index.html vs Index.html
       - if [ ! -f $CI_PROJECT_DIR/public/index.html ]; then echo "<meta http-equiv='refresh' content='0;url=Index.html'>" > $CI_PROJECT_DIR/public/index.html; fi
     artifacts:
       paths:
         - public
     tags:
       - docker


Advanced Configuration
======================

Advanced users may want to tweek the configuration somewhat for various
reasons. Here's an example of how to change the default script to specific
needs.

.. code-block:: yaml

   docu:
     stage: test
     image:
       name: t3docs/render-documentation:v2.3.0
       entrypoint: [""]
     before_script:
       # Copy the content of the current folder to /PROJECT
       # This is needed, because the path is hardcoded and cannot be configured in v2.3.0
       - cp -a ${CI_PROJECT_DIR}/. /PROJECT
       # Alternatively you can symlink the folder, too
       #    - rm -rf /PROJECT && ln -s ${CI_PROJECT_DIR} /PROJECT
       # If you set -c resultdir to some path, but you need to make sure the folder exists beforehand
       - export resultdir=${CI_PROJECT_DIR}/Documentation-GENERATED-temp
       - mkdir -p ${CI_PROJECT_DIR}/Documentation-GENERATED-temp
       # Alternatively, symlink the /RESULT to somewhere inside the ${CI_PROJECT_DIR} since Gitlab
       # will not accept artiacts from outside of this path
       #    - ln -s /RESULT ${CI_PROJECT_DIR}/Documentation-built
     script:
       # Make sure to be in /ALL/venv, else this will not work!
       - cd /ALL/venv
       # Execute
       - /ALL/Menu/mainmenu.sh makehtml-no-cache -c resultdir $resultdir
       # fix problem with index.html vs Index.html
       - if [ ! -f $CI_PROJECT_DIR/$resultdir/Result/project/0.0.0/index.html ]; then echo "<meta http-equiv='refresh' content='0;url=Index.html'>" > $CI_PROJECT_DIR/$resultdir/Result/project/0.0.0//index.html; fi
     # Only available for Gitlab Runners 12.3+! Run the script only if something changed in the documentation
     rules:
       - changes:
           - Documentation
         when: always
       - when: never
     artifacts:
       paths:
         - ${CI_PROJECT_DIR}/Documentation-GENERATED-temp/


Additonal information
=====================

Terms: :term:`RenderDocumentation`, :term:`TCT`, :term:`toolchain`

Here is some additional information you may be looking for.

**Note:** `TCT` is our toolchain runner. It runs
`RenderDocumentation` which is our toolchain.


`dockrun_t3rd` or `docker run`?
-------------------------------

Terms: :term:`dockrun`

The `dockrun_t3rd` function is just a helper tool to help assembling the final
Docker command. If you are not using this helper write the explicite form in
the examples below. The explicite form is::

   # instead of dockrun_t3rd write:
   OUR_IMAGE_TAG=v2.3.0           <-- for example
   OUT_IMAGE_TAG=develop          <-- adapt
   docker run --rm t3docs/render-documentation:$OUR_IMAGE_TAG


.. index:: Gitlab CI; TCT

Parameters of TCT
-----------------

Terms: :term:`TCT`

Use `--help`::

   dockrun_t3rd tct --help
   dockrun_t3rd tct run --help


Parameters of the toolchain "RenderDocumentation"
-------------------------------------------------

Only the toolchain itself knows which parameters and options it takes. So we
have to run the toolchain and ask for that information like so::

   dockrun_t3rd tct run RenderDocumentation --toolchain-help


You should be seeing something like this::

   ➜  ~ dockrun_t3rd tct run RenderDocumentation --toolchain-help

   Usage: tct run [OPTIONS] RenderDocumentation

     Run the toolchain 'RenderDocumentation'.

   Options:
     -c, --config KEY VALUE          Define or override config key-value pair
                                     (repeatable)
     -n, --dry-run                   Perform a trial run with no changes made.
     --toolchain-help                Tell the toolchain to display its help text.
                                     The toolchain should do that and then exit.
     -T, --toolchain-action ACTION   Tell the toolchain to execute the action.
                                     (repeatable)
     --help                          Show this message and exit.

   Toolchain options:
     -T clean                        Let the toolchain delete prior builds, then exit.
     -T help                         Show toolchain help and e exit.
     -T unlock                       Remove possible lock and exit.
     -T version                      Show toolchain version and exit.

     -c makedir PATH/TO/MAKEDIR      Required! The path to the 'make' folder.
     -c resultdir PATH/TO/MAKEDIR    Optional. The path to the
                                     'Documentation-GENERATED-temp' folder. Must
                                     exist if specified.

     -c buildsettings PATH/TO/FILE   If specified, this file overrides the normal
                                     makedir/buildsettings.sh

     -c overrides PATH/TO/FILE       If specified, this file is used instead of the
                                     normal makedir/Overrides.cfg

     -c rebuild_needed 1             Force rebuild regardless of checksum

     -c make_singlehtml 1            yes (default)
     -c make_singlehtml 0            no

     -c make_latex 1                 yes! Make LaTeX and PDF(default)
     -c make_latex 0                 no

     -c make_package 1               yes (default)
     -c make_package 0               no

     -c talk 0                       run quietly
     -c talk 1                       talk just the minimum (default)
     -c talk 2                       talk more

     -c jobfile PATH/TO/JOBFILE.JSON  pass in all kind of settings

     -c email_user_to_instead  "email1,email2,..."  instead of real user
     -c email_user_cc  "email1,email2,..."  additionally, publicly
     -c email_user_bcc "email1,email2,..."  additionally, secretly
     -c email_user_send_to_admin_too  1     like it says

   ➜



Parameters for `/ALL/mainmenu.sh`
---------------------------------

The build script comes with several shorthands to make building the
documentation easier. The most interesting ones are::

   makeall                Means: -c make_latex 1 -c make_package 1 -c make_pdf 1 -c make_singlehtml 1
   makeall-no-cache       Same as makeall, but clean cache first
   makehtml               Means: -c make_latex 0 -c make_package 0 -c make_pdf 0 -c make_singlehtml 0
   makehtml-no-cache      Same as makehtml, but clean cache first


You can ask the container to show a more explicite text. Here is an example::

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
               makeall              Create all output formats
               makeall-no-cache     Remove cache first, then create all
               makehtml             Create HTML output
               makehtml-no-cache    Remove cache first, then build HTML
               show-shell-commands  Show useful shell commands and functions
               show-howto           Show howto (not totally up to date)
               show-faq             Show questions and answers (not totally up to date)
               bashcmd              Run a bash command in the container
               /bin/bash            Enter the container's Bash shell as superuser
               /usr/bin/bash        Enter the container's Bash shell as normal user
               export-ALL           Copy /ALL to /RESULT/ALL-exported
               tct                  Run TCT, the toolchain runner

       Examples:
           dockrun_t3rd
           dockrun_t3rd --help
           dockrun_t3rd export-ALL
           dockrun_t3rd makeall-no-cache
           dockrun_t3rd makehtml
           dockrun_t3rd bashcmd 'ls -la /ALL'
           dockrun_t3rd /bin/bash
           dockrun_t3rd /usr/bin/bash

   End of usage.


   ➜  ~


.. index:: Gitlab CI; jobfile.json


About Documentation/jobfile.json
--------------------------------

Terms: :term:`jobfile`

**For container version v2.3.0 or newer**

This file is very powerful and will override almost all settings that have been
made before in the process. You can use it only on machines where you are the
administrator or operator yourself. The rendering of official documentation for
the TYPO3 docs server is done with a jobfile that you cannot control.
The :file:`jobfile.json` file is maintained with your project OUTSIDE the
container. But it is used at run time WITHIN the container. So when you start
the container and pass the file location you have to specify one that's valid
WITHIN the container.
A good choice to place the file is in
:file:`YOUR-PROJECT/Documentation/jobfile.json`. In that case you would add
`-c jobfile /PROJECT/Documentation/jobfile.json` to the Docker run command.
Another obvious place would be
:file:`YOUR-PROJECT/Documentation-GENERATED-temp/jobfile.json`, especially if
the jobfile gets generated somehow. In that case the command line needs to have
`-c jobfile /RESULT/Documentation/jobfile.json`.
The name :file:`jobfile` is just a - useful - convention. It could as well be a
json file named :file:`abc.json`, for which you would write
`-c jobfile /PROJECT/Documentation/abc.json`.

As of container version v2.3.0 we have the following. This will probably be
extended with newer versions. Some settings are postfixed with '_DISABLED'
which can be removed to activate them.

Minimal, no operation
   ::

     {
       "Overrides_cfg": {
         "comment": "This section goes into conf.py, which is the Sphinx config file",
         "general": {
         }
       },
       "tctconfig": {
          "comment": "This sections defines how the toolchain behaves",
        },
       "dockrun_t3rd": {
          "comment_1": "This can be used on the local machine to define the build call",
          "comment_2": "set action to makehtml, makehtml-no-cache, makeall, makeall-no-cache",
          "action": "makehtml-no-cache",
          "jobfile_option": " -c jobfile /PROJECT/Documentation/jobfile.json"
        }
     }


Extensive
   ::

     {
       "Overrides_cfg": {
         "comment": "This section goes into conf.py, which is the Sphinx config file",
         "general": {
           "html_theme": "t3SphinxThemeRtd",
           "keep_warnings": 0,
           "language": "en",
           "html_logo_DISABLED": "../TheProject/Documentation/_static/logo.svg",
           "html_css_files": ["css/my-extra.css"],
           "html_static_path_DISABLED": ["../TheProject/Documentation/_static"],
           "nitpicky": false,
           "nitpick_ignore": [["py:class", "type"]],
           "project": "The Project",
           "release": "9.8.7",
           "rst_epilog": "",
           "rst_prolog_DISABLED": "\n.. This is 'Includes.txt'. It is included at the very top of each and\n   every ReST source file in THIS documentation project (= manual).\n\n.. role:: aspect (emphasis)\n.. role:: html(code)\n.. role:: js(code)\n.. role:: php(code)\n.. role:: typoscript(code)\n.. role:: ts(typoscript)\n   :class: typoscript\n\n.. highlight:: php\n.. default-role:: code\n",
           "version": "9.8",
           "zzz": 0
         }
       },
       "tctconfig": {
          "comment": "This sections defines how the toolchain behaves",
          "activateLocalSphinxDebugging": 0,
          "disable_include_files_check": 1,
          "force_rebuild_needed": 1,
          "make_html": 1,
          "make_latex": 0,
          "make_pdf": 0,
          "make_singlehtml": 0,
          "rebuild_needed": 1,
          "replace_static_in_html": 1,
          "reveal_exitcodes": 1,
          "reveal_milestones": 1,
          "talk": 1,
          "try_pdf_build_from_published_latex": 1
        },
       "dockrun_t3rd": {
          "comment_1": "This can be used on the local machine to define the build call",
          "comment_2": "set action to makehtml, makehtml-no-cache, makeall, makeall-no-cache",
          "action": "makehtml-no-cache",
          "jobfile_option": " -c jobfile /PROJECT/Documentation/jobfile.json"
        }
     }


.. index:: sphinx_rtd_theme; Edit on GitLab button

"Edit on GitLab" button with the sphinx_rtd_theme
=================================================

The corresponding html template looks like this:

.. code-block:: jinja

   <a href="https://{{ gitlab_host|default("gitlab.com") }}/{{ gitlab_user }}/{{ gitlab_repo }}/{{ theme_vcs_pageview_mode|default("blob") }}/{{ gitlab_version }}{{ conf_py_path }}{{ pagename }}{{ suffix }}" class="fa fa-gitlab"> {{ _('Edit on GitLab') }}</a>


Edit a single file
------------------

Have something like this in your :file:`jobfile.json` file:

.. code-block:: json

   {
     "Overrides_cfg": {
       "general": {
         "html_theme": "sphinx_rtd_theme",
         "html_context": {
           "display_gitlab": true,
           "gitlab_host": "gitlab.com",
           "gitlab_user":"GITLAB_USER",
           "gitlab_repo": "GITLAB_REPO",
           "theme_vcs_pageview_mode": "edit",
           "gitlab_version": "master/",
           "conf_py_path": "Documentation/"
         },
   }


Edit the file in GitLab WEB Ide
-------------------------------

Have something like this in your :file:`jobfile.json` file:

.. code-block:: json

   {
     "Overrides_cfg": {
       "general": {
         "html_theme": "sphinx_rtd_theme",
         "html_context": {
           "display_gitlab": true,
           "gitlab_host": "gitlab.com",
           "gitlab_user":"-/ide/project/GITLAB_USER",
           "gitlab_repo": "GITLAB_REPO",
           "theme_vcs_pageview_mode": "edit",
           "gitlab_version": "master/-/",
           "conf_py_path": "Documentation/"
         },
   }


.. index:: sphinx_rtd_theme; your own logo, sphinx_rtd_theme; your own css

Your own logo and css with the sphinx_rtd_theme
===============================================

To configure your own logo with the ReadTheDocs theme you need to know the
relative path from `conf.py` to the logo. Suppose your file structure looks
like this:

.. code-block:: text

   MyProject
   └── Documentation
       ├── jobfile.json
       ├── Index.rst
       └── _static
           ├── my-logo.svg
           └── css
               └── my-styles.css


The relative path we are looking for is a constant and reflects some of the
internals of the container. This constant, which is the relative path to go
from the :file:`conf.py` folder to the documentation start is
:file:`../TheProject/Documentation`. So to use :file:`my-logo.png` and
:file:`my-styles.css` you would write the following in :file:`jobfile.json`.
To make it a bit more complete project, release and version are shown as well:

.. code-block:: json

   {
     "Overrides_cfg": {
       "general": {
         "html_theme": "sphinx_rtd_theme",
         "html_logo": "../TheProject/Documentation/_static/my-logo.svg",
         "html_css_files": ["css/my-styles.css"],
         "html_static_path": ["../TheProject/Documentation/_static"],
         "project": "MyProject",
         "release": "1.0.0",
         "version": "1.0",
       }
     },


Personal use of container v2.6
==============================

Run the container:

.. code-block:: shell

   cd mbw-the-mbless-world
   dockrun_t3rd makehtml-no-cache -c jobfile /PROJECT/Documentation/jobfile.json



File :file:`mbw-the-mbless-world/Documentation/jobfile.json`:

.. code-block:: json

   {
      "Overrides_cfg": {
         "general": {
            "html_theme": "sphinx_typo3_theme",
            "html_theme_options": {},
            "html_logo": "../TheProject/Documentation/_static/logo/logo.png",
            "html_css_files": ["css/mbwstyles.css"],
            "html_favicon": "../TheProject/Documentation/_static/icons/favicon.ico",
            "html_static_path": ["../TheProject/Documentation/_static"],
            "html_context": {
               "display_gitlab": true,
               "gitlab_protocol": "http://",
               "gitlab_host": "gitlab.local.mbless.de:81",
               "gitlab_user":"-/ide/project/marble",
               "gitlab_repo": "mbw-the-mbless-world",
               "theme_vcs_pageview_mode": "edit",
               "gitlab_version": "master/-/",
               "conf_py_path": "Documentation/"
            },
            "keep_warnings": 0,
            "nitpicky": false,
            "nitpick_ignore": [["py:class", "type"]],
            "project": "MBW - The Mbless World",
            "release": "1.0.0",
            "rst_epilog": "",
            "rst_prolog_DISABLED": "\n.. This is 'Includes.txt'. It is included at the very top of each and\n   every ReST source file in THIS documentation project (= manual).\n\n.. role:: aspect (emphasis)\n.. role:: html(code)\n.. role:: js(code)\n.. role:: php(code)\n.. role:: typoscript(code)\n.. role:: ts(typoscript)\n   :class: typoscript\n\n.. highlight:: php\n.. default-role:: code\n",
            "smartquotes": false,
            "templates_path": ["../TheProject/Documentation/_templates"],
             "todo_include_todos": true,
            "version": "1.0",
            "zzz": 0
         }
      },
      "tctconfig": {
         "activateLocalSphinxDebugging": 0,
         "disable_include_files_check": 1,
         "force_rebuild_needed": 1,
         "make_html": 1,
         "make_latex": 0,
         "make_pdf": 0,
         "make_singlehtml": 0,
         "rebuild_needed": 1,
         "replace_static_in_html": 0,
         "reveal_exitcodes": 1,
         "reveal_milestones": 1,
         "talk": 1,
         "try_pdf_build_from_published_latex": 1
      }
   }



File structure:

.. code-block:: text

   .
   ├── Documentation
   │   ├── 00-Todo
   │   │   ├── Explore-this
   │   │   │   └── Index.rst
   │   │   └── Index.rst
   │   ├── 90-Targets.rst
   │   ├── 91-Sitemap.rst.txt
   │   ├── genindex.rst
   │   ├── Includes.rst.txt
   │   ├── Index.rst
   │   ├── jobfile.json
   │   ├── _static
   │   │   ├── css
   │   │   │   └── mbwstyles.css
   │   │   ├── icons
   │   │   │   └── favicon.ico
   │   │   └── logo
   │   │       ├── logo-242x242.png
   │   │       └── logo.png
   │   └── _templates
   │       ├── breadcrumbs.html
   │       └── sitemap.html
   └── Documentation-GENERATED-temp
       ├── Cache
       ├── last-docker-run-command-GENERATED.sh.txt
       ├── Result
       │   ├── exitcodes.json
       │   ├── milestones.json
       │   ├── project
       │   │   └── 0.0.0
       │   │       ├── 00-Todo
       │   │       │   ├── Explore-this
       │   │       │   │   └── Index.html
       │   │       │   └── Index.html
       │   │       ├── Index.html
       │   │       ├── objects.inv
       │   │       ├── search.html
       │   │       ├── searchindex.js
       │   │       ├── _sources
       │   │       │   ├── 00-Todo
       │   │       │   │   ├── Explore-this
       │   │       │   │   │   └── Index.rst.txt
       │   │       │   │   └── Index.rst.txt
       │   │       └── _static
       │   │           ├── css
       │   │           │   ├── fontawesome.css
       │   │           │   ├── mbwstyles.css
       │   │           │   ├── theme.css
       │   │           │   └── webfonts.css
       │   │           ├── favicon.ico
       │   │           ├── fonts
       │   │           │   ├── ...
       │   │           │   └── ...
       │   │           ├── graphviz.css
       │   │           ├── icons
       │   │           │   └── favicon.ico
       │   │           ├── img
       │   │           │   └── typo3-logo.svg
       │   │           ├── js
       │   │           │   ├── autocomplete.min.js
       │   │           │   └── ...
       │   │           ├── language_data.js
       │   │           ├── logo
       │   │           │   ├── logo-242x242.png
       │   │           │   └── logo.png
       │   │           ├── logo.png
       │   │           ├── pygments.css
       │   │           └── ...
       │   └── publish-params.json
       └── warning-files.txt

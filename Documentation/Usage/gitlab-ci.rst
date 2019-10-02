.. include:: ../Includes.txt

=====================
Render with Gitlab CI
=====================

This page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top


Pre-Requesites
==============

Make sure you have a running Gitlab CI pipeline and that a runner is assigned to your project.

Basic Configuration
===================

This basic configuration should cover the needs of most users as it will expose the content to the public folder,
so that if you already have pages configured, you'll just need this.

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

Advanced users might want to tweek the configuration somewhat for various reasons. Here's an example
on how you can change the default script to your needs.

   .. code-block:: yaml

      docu:
        stage: docs
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

Additional Parameters for `/ALL/mainmenu.sh`
--------------------------------------------

Taken from the documentation toolchain `10-Toolchain-actions/run_02-Show-help-and-exit.py` (not extensive):

   .. code-block:: text

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

Shorthand options for `/ALL/mainmenu.sh`
----------------------------------------

The build script comes with several shorthands to make building the documentation easier:

   .. code-block:: test

        makeall                          Same as -c make_latex 1 -c make_package 1 -c make_pdf 1 -c make_singlehtml 1
        makeall-no-cache                 Same as makeall, but clean cache first
        makehtml                         Same as -c make_latex 0 -c make_package 0 -c make_pdf 0 -c make_singlehtml 0
        makehtml-no-cache                Same as makehtml, but clean cache first

Documentation/jobfile.json
--------------------------

This file allows you to override some configurations that you might need, like using a different theme, or overwriting some
css definitions. Just add the parameter `-c jobfile Documentation/jobfile.json` when executing `/ALL/Menu/Mainmenu.sh` in order to use this.

   .. code-block:: json

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

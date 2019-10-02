.. include:: /Includes.rst.txt

==================
Advanced usage
==================

This page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top


Use you own theme
=================

.. versionadded:: v2.4.0-dev

The syntax given here makes use of the `dockrun_t3rd` function.


Provide the theme
-----------------

1. Locate the folder with the local Sphinx theme you want to use. For example::

      theme_dir=~/Repositories/github.com/sphinx_rtd_theme/sphinx_rtd_theme
      theme_parent_dir=~/Repositories/github.com/sphinx_rtd_theme

2. Assume a project :file:`~/project`::

      project_dir=~/project

3. Provide the theme. There are two possibilities: Create an envvar or use a
   folder. The envvar method has higher priority.

   (a) Using envvar T3DOCS_THEMES

       Set the variable to the *containing* (=parent) folder of the theme::

          T3DOCS_THEMES=$theme_parent_dir

   (b) Create a folder with the special name `tmp-GENERATED-Themes`::

          destdir=$projectdir/tmp-GENERATED-Themes
          mkdir -p $dest_dir

       Copy *themedir* into the folder::

          cp -r $theme_dir $dest_dir

       You may then rename the folder that holds your theme to a name you like.
       It is that folder name that you will have to mention later in the
       configuration of your rendering.


Select and use the theme
------------------------

1. In :file:`$project_dir/Documentation/jobfile.json` write:

   .. code-block:: json

      {
         "Overrides_cfg": {
            "general": {
               "html_theme": "Specify-FOLDER-NAME-of-desired-theme-here"
            }
         }
      }

2. Render::

      cd $project_dir
      dockrun_t3rd  makehtml  -c jobfile /PROJECT/Documentation/jobfile.json



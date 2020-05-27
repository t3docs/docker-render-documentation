.. include:: /Includes.rst.txt
.. index:: development; theme
.. _Theme-development:

=================
Theme development
=================

The following shows how to clone our theme for development, how to make it
available in our Docker render container and how to render documentation using
the new theme.

.. contents:: This page
   :backlinks: top
   :class: compact-list
   :depth: 3
   :local:


Prepare theme for development
=============================

Create a local folder to hold themes. Let's name that folder :file:`~/THEMES`::

   mkdir ~/THEMES


Clone theme for development::

   # garantee folder
   mkdir -p ~/Repositories/github.com/TYPO3-Documentation

   # go there
   cd ~/Repositories/github.com/TYPO3-Documentation

   # clone
   git clone https://github.com/typo3-documentation/t3SphinxThemeRtd


Use npm, yarn, grunt, … to provide all resources and to run a build. For example::

   cd ~/Repositories/github.com/typo3-documentation/t3SphinxThemeRtd

   # install packages
   yarn

   # build
   grunt

   # At this point a new version of the theme should have been built

Example::

   ➜  t3SphinxThemeRtd git:(feature/abc) ✗ grunt
   Running "clean:build" (clean) task

   Running "clean:fonts" (clean) task
   Cleaning t3SphinxThemeRtd/static/fonts...OK

   Running "copy:fonts" (copy) task
   Copied 40 files

   Running "sass:build" (sass) task

   Done, without errors.


Copy the new build to the THEMES folder, thereby giving it a name that is not
in the list of available themes so far::

   # WITH slash at the end of source!
   source=~/Repositories/github.com/TYPO3-Documentation/t3SphinxThemeRtd/t3SphinxThemeRtd/

   # WITH slash at the end of dest!
   dest=~/THEMES/t3SphinxThemeRtdDevelop/

   rsync -avii -delete $source $dest

   #


So there should exist a new folder :file:`~/THEMES/t3SphinxThemeRtdDevelop`.
In your documentation you have to specify that name as desired theme.


Use the dev theme
=================

.. versionadded:: v2.4.0


Make THEMES available
---------------------

Here we assume that the dockrun helper function is available.
In a terminal window::

   # turn some debug output on
   T3DOCS_DEBUG=1

   # point to your THEMES folder. If this envvar is set it will automatically
   # be mapped into the container.
   T3DOCS_THEMES=~/THEMES

   # go to you project
   cd ~/project

   # use the container like normal
   dockrun_t3rd


There should be output similar to the following. Note that you should see a
mapping of the :file:`~/THEMES` folder:

.. code-block:: text

   PROJECT......: ~/project
   creating: mkdir -p ~/project/Documentation-GENERATED-temp
   RESULT.......: ~/project/Documentation-GENERATED-temp
   THEMES.......: ~/THEMES
   OUR_IMAGE....: t3docs/render-documentation:v2.4.0
   docker run --rm --user=1000:1000 \
      -v ~/project:/PROJECT:ro \
      -v ~/project/Documentation-GENERATED-temp:/RESULT \
      -v ~/THEMES:/THEMES \
      t3docs/render-documentation:v2.4.0
   t3rd - TYPO3 render documentation (v2.4.0)
   For help:
      docker run --rm t3docs/render-documentation:v2.4.0 --help
      dockrun_t3rd --help

   ... did you mean 'dockrun_t3rd makehtml'?


Set up your documentation
-------------------------

You *cannot* specify your theme in :file:`Settings.cfg` as that value gets
overriden and will always be 't3SphinxThemeRtd' in the end.

You *can* set the theme in :file:`./Documentation/jobfile.json` however like
so:

.. code-block:: json

   {
     "Overrides_cfg": {
       "general": {
         "html_theme": "t3SphinxThemeRtdDevelop"
       }
     }
   }


Additionally theme options may be of special interest.

*Attention:* ANY non empty string is considered to be TRUE.

.. code-block:: json

   {
     "Overrides_cfg": {
       "html_theme_options": {
         "docstypo3org": "yes",
         "add_piwik": "yes",
         "show_legalinfo": "yes"
       }
     },
   }


*Attention:* Use the empty string to specify FALSE.

.. code-block:: json

   {
     "Overrides_cfg": {
       "html_theme_options": {
         "docstypo3org": "",
         "add_piwik": "",
         "show_legalinfo": ""
       }
     },
   }


Finally - use it like hell :-)
==============================

Start rendering and developing using normal procedures::

   dockrun_t3rd  makehtml  -c jobfile /PROJECT/Documentation/jobfile.json


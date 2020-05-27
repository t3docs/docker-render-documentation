.. include:: /Includes.rst.txt
.. highlight:: shell


=========================
Usage at the build server
=========================

TYPO3 has "living" documentation. Documentation is automatically
(re)rendered and published on https://docs.typo3.org when it changes.
There is an `Intercept
<https://intercept.typo3.com/admin/docs/deployments>`_ machine that reveals
the status of the various automation jobs.

----

This document is about how the docker container is used on the build server
and how updates are done.

.. contents:: This page
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top


Updating to v2.6.1
==================

:Jira: `Please deploy new Docker docs rendering container v2.6.1
       <https://jira.typo3.com/servicedesk/customer/portal/2/T3GFEED-2>`__

Step one
--------

Can be done right away and is independent from step two.

① A new documentation rendering container is available and should be used in
Bamboo plans. New: `docker pull t3docs/render-documentation:v2.6.1`.
Currently we are using `v2.5.1`. So please change that to `v2.6.1`. This change
is ready to go and should work for all manuals.

② This should be working fine and be a drop in replacement. Reverting to
v2.5.1 is always possible though.

③ Once it works all manuals should be re-rendered.

Step two
--------

Update in plans requested:

The footer of new renderings now shows a "Last updated" date for files that
live in a Git repository. The container will query `git log` automatically if
the root of the repository is mapped as `PROJECT` into the container. If,
however, for example, the repository is `TYPO3CMS.git` and the PROJECT is
`typo3/sysext/core` then the container cannot query Git as the complete
repository is not mapped into the container. To make things work the following
has to be done:

1. Make this script available: `git-restore-mtime-modified.py
   <https://github.com/marble/Toolchain_RenderDocumentation/blob/master/16-Convert-and-fix-and-check/git-restore-mtime/git-restore-mtime-modified.py>`_

2. Insert code BEFORE the line with the `docker run ...` call::

      # go to the project
      cd PROJECT

      # run the script
      python git-restore-mtime-modified.py --test --destfile-gitloginfo=.gitloginfo-GENERATED.json .

   Note the single dot at the end which denotes the current directory!

   *Explanation:*
   `--test` means that file mtimes are not really to be changed as the script
   would usually do. It doesn't hurt but is of no use either. As result an
   outfile :file:`PROJECT/.gitloginfo-GENERATED.json` should exist with
   information extracted from `git log`. The container with the toolchain will
   then automatically make use of that information. The Bamboo plan does not
   have to check for success. The script will only write the result file on
   success, and the container will only use it if it's available and in proper
   shape.

Thank you for all!


----

:Jira: Report `Docs Rendering Issues <https://jira.typo3.com/servicedesk/customer/portal/3/create/128>`__ here

----

Today is 21. October 2019
=========================

"now", "currently" and "today" refers to this date in the context of this page.


Released today: version v2.4.0
==============================

**v2.4.0** is now active and replaces v2.3.0


Update from v2.3.0 to current v2.4.0
====================================

How to update the Docker render container.


For example: Update v2.3.0 to v2.4.0
------------------------------------

1. Find server idle time or pause scheduling of new rendering jobs.

2. Update the rendering script. This should be something like
   'Render documentation' of type
   'com.atlassian.bamboo.plugins.scripttask:task.builder.script'.

   Do a "find & replace" operation::

      # find........:  t3docs/render-documentation:v2.3.0
      # replace with:  t3docs/render-documentation:v2.4.0

3. Trigger a sample rendering.

4. Check the result and the log output to verify that rendering and deployment
   succeeded.

5. In case of error: revert to v2.3.0 and contact the documentation team.

6. In case of success: Trigger rerendering of all known manuals.

7. Resume normal job processing.

**Note:** With v2.4.0 there is NO NEED to rerender all manuals.


Update from v2.2.6 to past v2.3.0
=================================

Extended check after updating to v2.3.0
---------------------------------------

After building have a look at the `results.json` file in the BUILDINFO.

v2.3.0 leaves more info there than the versions before. You may especially want
to watch to have a look at the "environ" section.


Here is an example `results.json` file:

.. code-block:: json

   {
     "build_time": "2019-08-26 14:39:11",
     "checksum": "7a3807bc4d86e9227bb20d555d62fbce",
     "checksum_ttl_seconds": 604800,
     "copyright": "TYPO3 Documentation Team",
     "created": {
       "html": 1,
       "singlehtml": 1
     },
     "description": "\nEverything about the container: How it works, how it's developed and build\nand way to use it.",
     "email_notify_about_new_build": [],
     "emails_user_from_project": [
       "martin.bless@typo3.org"
     ],
     "environ": {
       "OUR_IMAGE": "t3docs/render-documentation:v2.3.0",
       "OUR_IMAGE_SHORT": "t3rd",
       "OUR_IMAGE_VERSION": "v2.3.0",
       "THEME_MTIME": "1530870718",
       "THEME_VERSION": "3.6.16",
       "TOOLCHAIN_VERSION": "2.8-dev",
       "TYPOSCRIPT_PY_VERSION": "v2.2.4"
     },
     "gitdir": "/PROJECT",
     "has_neutralized_images": 0,
     "has_neutralized_links": 0,
     "known_versions": {
       "t3SphinxThemeRtd.VERSION": [
         3,
         6,
         16
       ],
       "t3SphinxThemeRtd.__version__": "3.6.16"
     },
     "localization": "default",
     "postprocessed_html_files": 0,
     "project": "TYPO3 Docker Container v2.3.0 for Documentation Rendering\nand more",
     "publish_dir": "project/0.0.0",
     "release": "0.1.9-draft",
     "sitemap_files_html_count": 42,
     "sitemap_files_singlehtml_count": 1,
     "ter_extension": "0"
   }


.. highlight:: shell

Check specifics of all rendered manuals::

   # command
   find -name results.json -exec grep -i 'has_neutralized_links": [^0]' {} +

   # findings
   #01 ./m/typo3/reference-typoscript/6.2/en-us/_buildinfo/results.json:  "has_neutralized_links": 1,
   #02 ./m/typo3/reference-typoscript/7.6/en-us/_buildinfo/results.json:  "has_neutralized_links": 1,
   #03 ./other/typo3/view-helper-reference/8.7/en-us/_buildinfo/results.json:  "has_neutralized_links": 1,

   …

Investigation of #01 and #02: The html contains `<a href="data:cols …` which
is detected as a possible threat. But, in the context of the TypoScript manual
it has the purpose to link to the 'cols' property of the 'data' object.


Container history
=================

v2.4.0
   t3docs/render-documentation:v2.4.0

   Released 21. October 2019

   To become active.

   Should be a "drop in" replacement.

   There is NO NEED to rerender all manuals.


v2.3.0
   t3docs/render-documentation:v2.3.0

   Released 19. August 2019

   Active since 27. August 2019.

   Was a "drop in" replacement.

   All manuals known to Intercept_ have been rerendered.


v2.2.6
   Released 23. June 2019

   Is currently in use.

   All manuals known to Intercept_ had been rerendered.

   Replaced v1.6.11-html

   This should have been a "drop in" replacement but didn't work initially
   due to a wrong environment variable in the script.


v1.6.11-html
   Released 26. October 2018

   First version that was used in the automated rendering process.

Tickets
=======

https://jira.typo3.com/servicedesk/customer/portal/3/TE-123


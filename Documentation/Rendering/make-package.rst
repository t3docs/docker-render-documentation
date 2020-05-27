.. include:: /Includes.rst.txt


==================
Creating packages
==================

Possible.

Examples::

   dockrun_t3rd  makeall
   dockrun_t3rd  makehtml  -c make_package 1


Produces :file:`Documentation-GENERATED-temp/Result/package/package.zip`

Contains html and singlehtml.

Smaller, as most font files are removed and css for "no fonts" is used.

Piwik calls are removed.

Security settings are not affected by just selecting 'make_package'.

`.doctrees` are excluded.

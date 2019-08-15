.. include:: ../Includes.txt

==================
Caching
==================

Navigate this page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top



Example: sysext:core
====================

First run
---------

Takes 30 minutes or more.

Remove all previous cache and build all::

   cd ~/Repositories/git.typo3.org/Packages/TYPO3.CMS.git/typo3/sysext/core
   git pull
   dockrun_t3rd  makeall-no-cache


Followup run
------------

Takes only seconds::




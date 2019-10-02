.. include:: /Includes.rst.txt


======================================
Drop the usual Includes.rst.txt file
======================================

**This page:**

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top


Method 1: Include the file
==========================

The usual TYPO3 convention. Works everywhere. But often paths need to be
adjusted after copying pages to another level.

We have the convention to always include a project-wide :file:`Include.txt`
file at the top of each reST file.


Method 2: Define in Settings.cfg
================================

Untried alternative. Works everywhere. No path adjustment.

As an alternative you may specify the content of that file as setting
`rst_prolog` in the :file:`Settings.cfg` file in the `general` section.
See the `Sphinx docs about conf.py
<http://www.sphinx-doc.org/en/master/usage/configuration.html>`__.

((Todo: figure out, elaborate, describe))


Method 3: Define in jobfile.json
================================

Works for local renderings with the Docker container. No path adjustment.

Consider a common includes file :file:`Includes.rst.txt` with the following content:

.. code-block:: rst

   .. This is 'Includes.rst.txt'. It is included at the very top of each and
      every ReST source file in THIS documentation project (= manual).

   .. role:: aspect (emphasis)
   .. role:: html(code)
   .. role:: js(code)
   .. role:: php(code)
   .. role:: typoscript(code)
   .. role:: ts(typoscript)
      :class: typoscript

   .. highlight:: php
   .. default-role:: code

Instead of putting includes to the top of each and every reST file you can
pass these settings to Sphinx once as `rst_prolog` in :file:`jobfile.json`:

.. code-block:: json

   {
     "Overrides_cfg": {
       "general": {
         "rst_prolog": "\n.. This is 'Includes.txt'. It is included at the very top of each and\n   every ReST source file in THIS documentation project (= manual).\n\n.. role:: aspect (emphasis)\n.. role:: html(code)\n.. role:: js(code)\n.. role:: php(code)\n.. role:: typoscript(code)\n.. role:: ts(typoscript)\n   :class: typoscript\n\n.. highlight:: php\n.. default-role:: code\n",
       }
     }
   }

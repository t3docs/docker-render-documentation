.. include:: /Includes.rst.txt
.. _About-includes:

==================================
About includes
==================================

Summary
=======

include
 `include <http://docutils.sourceforge.net/docs/ref/rst/directives.html#including-an-external-document-fragment>`__
 is a directive that comes with :term:`Docutils`. It allows inclusion of text
 as if it were written at that point.

literalinclude
 `literalinclude
 <https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-literalinclude>`__
 is a directive known by Sphinx. It is used to show source code.

Both directives represent a potential security hole. That is why some sites
permanently disallow them by means of the Docutils "file_insertion_enabled"
setting. We don't do that, but apply an include-files-check instead.

**Enabled!**

① In the container both the `.. include::` and the `.. literalinclude::`
directive are enabled.

② A source code check will ensure that only
project files can be included. It signals alarm for all lines that look like
a real include.

③ Administrators can turn the include file check off.


Relative paths
==============

Consider a project with this file structure:

.. code-block:: text

   Project
   ├── Classes
   │   └── Helpers
   │       └── GetDoc.php
   ├── Documentation           <-- base dir of documentation
   │   ├── Chapter-1.rst
   │   └── Includes.rst.txt


In the file :file:`Chapter-1.rst` we can use these *relative* file specs::

   .. include:: Includes.rst.txt

   .. literalinclude:: ../Classes/Helpers/GetDoc.php



Absolute paths
==============

.. versionadded:: v2.4.0

If the included files are specified as absolute paths they are considered to
be starting at the **base dir of documentation** which currently is configured
to be :file:`Project/Documentation`. Absolute paths are secure. They can never
target files beyond the basedir.

.. tip::

   You may now write `.. include:: /Includes.rst.txt` in any ReST file you
   have, no matter how deep it's buried in the hierarchy.

   This means: You don't have to tweak the include when you move files around!



.. security; includes

Relative paths are being surveilled
===================================

Absolute paths are secure.

Relative paths represent a potential security hole.

They can address files that are
external to the project. For example, the following include *may* show a result
you probably wouldn't wish to see in the final html in the web:

.. code-block:: rst

   ..␠include:: ../../../../../etc/passwd

As a countermeasure the container checks all include paths. If a file from
outside the project is referenced the rendering will be aborted. No output
will be produced. A message is shown on stdout in the terminal window though.

.. attention::

   The include-file-check may run into false alarms as it only does a rough
   lexical analysis and not fully parses the reST code for speed reasons.
   So we have to disguise the include directive in the above code example
   by writing `..␠include::` instead of `.. include::`. Otherwise the example
   would prevent the manual from being rendered because that line *looks like*
   a real include directive, although it would never be executed.

Projectwide includes
====================

.. versionadded:: v2.4.0

All files in the project can be referenced with relative path specifications.

All files in and below the **base dir of documentation** can be referenced
with absolute path specifications.

**base dir of documentation** currently is :file:`Project/Documentation`.
If possible, this *may* be changed in future to :file:`Project/`.


Allow systemwide includes
=========================

The administrator can turn include file checking OFF in :file:`jobfile.json`
like so:

.. code-block:: json

   {
     "tctconfig": {
        "disable_include_files_check": 1
     }
   }

In that case any file reachable by a relative path can be included, no matter
if it belongs to the project or not.

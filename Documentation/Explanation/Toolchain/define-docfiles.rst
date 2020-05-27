.. include:: /Includes.rst.txt

.. _Specify-documentation-files:

===========================
Specify documentation files
===========================

Standard layout
===============

The container first makes a copy of your project and then starts documentation
rendering. However, because you never know how big projects may become,
especially if they include binary files, only the
toplevel files and the subfolder :file:`./Documentation/` is copied.
This arrangement is called 'standard layout'. Here is an example::

   .
   ├── Documentation
   │   ├── Index.rst
   │   ├── Settings.cfg
   │   ├── Includes.rst.txt
   │   ├── Settings.cfg
   │   └── …
   ├── CONTRIBUTE
   ├── LICENSE
   ├── LICENSE
   ├── README.rst
   └── …

Nothing special needs to be done if your project adheres to the standard
layout. However, to help understanding configuration syntax, here is how the
rules for standard layout would be written.

.. highlight:: ini

File :file:`./Documentation/Settings.cfg` is recommended to hold this
settings as this will work locally "at home" and on the build server::

   [get_documentation]

   # what to keep of the original project "PROJECT" for the documentation
   # rendering process "TheProject". Executed in alphabetical order (!)
   # of the key names (anyname_* in this example)

   anyname_01 = /PROJECT/*                   => /TheProject/
   anyname_02 = /PROJECT/Documentation/**/*  => /TheProject/Documentation/


`get_documentation` is the name of the section. Each following line affects
a single file or a group of files if the filename contains a wildcard
character '*' or '?'. The double star `/**/` means "recursively". So the
folder and all its subfolders will be taken into account. Each line is written
as 'SOURCE-FILE(S) => DESTINATION-FOLDER' and will trigger a system copy
command using `rsync`. The commands are given in alphabetical order of the
keys, no matter in which order you write down the lines.



Custom layout
=============

There may be reasons to spread the documentation source files to other areas
of your project. Or, maybe you want to use the `.. includeliteral::` directive
to directly include your source as code example. Then we have a
'custom layout' and you need to specify which extra files are need.

Examples
--------

Provide all PHP files as well::

   [get_documentation]
   dummy = /PROJECT/**/*.php => /TheProject


All \*.txt, \*.md, \*.rst text files::

   [get_documentation]
   dummy1 = /PROJECT/**/*.txt => /TheProject
   dummy2 = /PROJECT/**/*.md  => /TheProject
   dummy3 = /PROJECT/**/*.rst => /TheProject


Some extra folder trees::

   [get_documentation]
   dummy1 = /PROJECT/subproject-abc/Documentation/**/* => /TheProject/Documentation/Abc
   dummy2 = /PROJECT/subproject-bcd/Documentation/**/* => /TheProject/Documentation/Bcd
   dummy3 = /PROJECT/subproject-cde/Documentation/**/* => /TheProject/Documentation/Cde


Only PHP files from Classes::

   [get_documentation]
   dummy1 = /PROJECT/Classes/**/*.php => /TheProject/Classes


Just a single file::

   [get_documentation]
   dummy1 = /PROJECT/Configuration/TypoScript/setup.txt => /TheProject/Documentation/_files


If you need something extra AND you know that your whole project isn't too
big for the container you can as well include just everything::

   [get_documentation]
   dummy1 = /PROJECT/**/* => /TheProject



Where to put the configuration
==============================

The `get_documentation` section can go into
:file:`./Documentation/Settings.cfg` or into
:file:`./Documentation/jobfile.json`.

Settings.cfg will work locally and on the docs server. And it is easy to
maintain.

jobfile.json is more powerful, and, if given, will take precedence. It may
be handy to configure everything in just one place if you are the administrator
yourself.

jobfile.json is only available to the administrator. So you cannot
use jobfile.json to configure server renderings.

.. highlight:: json

For the current container versions v2.3 and v2.4 the crucial part of the
jobfile would be written as::

   {
      "tctconfig": {
         "get_documentation": {
            "anyname_01": "/PROJECT/* => /TheProject/",
            "anyname_02": "/PROJECT/Documentation/**/*"
         }
      }
   }

"tctconfig" is the section that describes how the toolchain should behave.

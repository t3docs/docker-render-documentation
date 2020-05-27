.. include:: /Includes.rst.txt


==========
Dockerfile
==========

Explain what's inside the container ...

Base is Ubuntu 18.04...

...

Important Folders
=================

Consider project `~/project/Documentation/…` on the host machine.

/PROJECT
   This is where the project is mapped to - in readonly mode.

/RESULT
   This is where the container writes the result.
   Corresponds usually to `Documentation-GENERATED-temp`.

/tmp
   Where all temporary files reside.

/THEMES
   Sphinx themes can be placed into this folder.

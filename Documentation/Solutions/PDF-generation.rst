.. include:: /Includes.rst.txt
.. highlight:: shell
.. _Individuell-Python-Packages:

==========================
Individual Python packages
==========================


.. contents:: This page
   :backlinks: top
   :class: compact-list
   :depth: 3
   :local:


Intention
=========

Python packages usually are distributed in a single "wheel" file named
`SOMETHING.whl`. Quite a bunch of such packages come installed with the
container and ready for use. There may be situations however where wished there
was an extra package installed or a different version. The container can handle
this "on the fly" for single runs and saves you the hassle of having to
`docker build` a specialized image.


How does it work?
=================

Within the container several convenience scripts (bash) are working and you
can select an action from the menu. The scripts now have an eye on the
:file:`/WHEELS` folder within the container. If there are :file:`*.whl` files
these are installed "on the fly" for the single run, for example, before
rendering takes place. Additionally a `pip freeze` command is run and reveals
in the listing on the console what exact Python packages are going to be used.
The idea is of course that you do a volume mapping to provide the wheels
packages and the :file:`/WHEELS` folder is otherwise empty by default.

Theme development is a perfect use case.
Let's say you want to try a variant of our theme `sphinx_typo3_theme`_.
Make some changes and as a result of your work build a local wheel file like
:file:`mywheels/sphinx_typo3_theme-4.2.1.dev4+ge50e4ff-py2.py3-none-any.whl`.
If you  then map the :file:`mywheels` folder into the container the modified
theme will be installed on the fly and will be used in the subsequent rendering.


Example 1
=========

Here you create a folder with a special name und use the `dockrun_t3rd`
command::

   # Think of ~/project/Documentation and go to your project
   cd ~/project

   # make a temp folder with this special name
   mkdir tmp-GENERATED-Wheels

   # place your wheel file(s) there
   cp fromsomewhere/sphinx_typo3_theme-4.2.1.dev4+ge50e4ff-py2.py3-none-any.whl tmp-GENERATED-Wheels/

   # Use the dockrun_t3rd command for rendering. It knows about the special name
   dockrun_t3rd makehtml


.. tip:: Use a global :file:`.gitignore` file and add the line `*GENERATED*`.


Example 2
=========

You may as well use the `dockrun_t3rd` command in junction with a special
environment variable::

   # Think of ~/project/Documentation and go to your project
   cd ~/project

   # specify the absolute path to your folder with wheel packages
   T3DOCS_WHEELS=/home/me/mywheels

   # ask for some extra console output for your enlightment
   T3DOCS_DEBUG=1

   # Use the dockrun_t3rd command for rendering. It knows about the envvars
   dockrun_t3rd makehtml


Example output
==============

In both the examples you should see on the console something like this:

.. code-block:: none

   ➜  dockrun_t3rd  makehtml
   Processing /WHEELS/sphinx_typo3_theme-4.2.1.dev4+ge50e4ff-py2.py3-none-any.whl
   Installing collected packages: sphinx-typo3-theme
     Attempting uninstall: sphinx-typo3-theme
       Found existing installation: sphinx-typo3-theme 4.2.1
       Uninstalling sphinx-typo3-theme-4.2.1:
         Successfully uninstalled sphinx-typo3-theme-4.2.1
   Successfully installed sphinx-typo3-theme-4.2.1.dev4+ge50e4ff
   ablog==0.9.5
   alabaster==0.7.12
   atomicwrites==1.4.0
   attrs==19.3.0
   Babel==2.8.0
   backports.functools-lru-cache==1.6.1
   beautifulsoup4==4.9.1
   certifi==2020.4.5.1
   chardet==3.0.4
   click==7.1.2
   commonmark==0.9.1
   configparser==4.0.2
   contextlib2==0.6.0.post1
   docutils==0.16
   funcparserlib==0.3.6
   funcsigs==1.0.2
   future==0.18.2
   idna==2.9
   imagesize==1.2.0
   importlib-metadata==1.6.0
   invoke==1.4.1
   Jinja2==2.11.2
   lxml==4.5.1
   MarkupSafe==1.1.1
   more-itertools==5.0.0
   packaging==20.4
   pathlib2==2.3.5
   Pillow==6.2.2
   pluggy==0.13.1
   py==1.8.1
   Pygments==2.5.2
   pyparsing==2.4.7
   pytest==4.6.10
   python-dateutil==2.8.1
   pytz==2020.1
   PyYAML==5.3.1
   recommonmark==0.6.0
   requests==2.23.0
   scandir==1.10.0
   six==1.15.0
   snowballstemmer==2.0.0
   soupsieve==1.9.6
   Sphinx==1.8.5
   sphinx-automodapi==0.12
   sphinx-rtd-theme==0.4.3
   sphinx-typo3-theme @ file:///WHEELS/sphinx_typo3_theme-4.2.1.dev4%2Bge50e4ff-py2.py3-none-any.whl
   sphinxcontrib-gitloginfo==1.0.0
   sphinxcontrib-googlechart @ https://github.com/TYPO3-Documentation/sphinx-contrib-googlechart/archive/t3v0.2.1.zip
   sphinxcontrib-googlemaps @ https://github.com/TYPO3-Documentation/sphinx-contrib-googlemaps/archive/t3v0.1.1.zip
   sphinxcontrib-phpdomain==0.7.0
   sphinxcontrib-slide @ https://github.com/TYPO3-Documentation/sphinx-contrib-slide/archive/t3v1.0.1.zip
   sphinxcontrib-websupport==1.1.2
   sphinxcontrib-youtube @ https://github.com/TYPO3-Documentation/sphinx-contrib-youtube/archive/t3v1.0.zip
   t3fieldlisttable @ https://github.com/TYPO3-Documentation/sphinxcontrib.t3fieldlisttable/archive/v0.3.0.zip
   t3sphinxtools-includecheck @ https://github.com/TYPO3-Documentation/t3SphinxTools_includecheck/archive/v1.0.0.zip
   t3tablerows @ https://github.com/TYPO3-Documentation/sphinxcontrib.t3tablerows/archive/v0.2.0.zip
   t3targets @ https://github.com/TYPO3-Documentation/sphinxcontrib.t3targets/archive/develop.zip
   TCT-Toolchain-Tool @ https://github.com/marble/TCT/archive/develop.zip
   typing==3.7.4.1
   urllib3==1.25.9
   wcwidth==0.1.9
   Werkzeug==1.0.1
   zipp==1.2.0

   ==================================================
      10-Toolchain-actions/run_01-Start-with-everything.py
      exitcode:   0            36 ms

   ==================================================
      10-Toolchain-actions/run_02-Show-help-and-exit.py
      exitcode:   0            35 ms


Limitations
===========

Note that this method of "on the fly installation" is limited to updating
Python packages only. You *can* install a `sphinxcontrib-plantuml` extension
for example. However, it will not work because the required Java packages are
not installed in the container.


.. _sphinx_typo3_theme: https://github.com/TYPO3-Documentation/sphinx_typo3_theme

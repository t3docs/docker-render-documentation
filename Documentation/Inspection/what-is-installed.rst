.. include:: /Includes.rst.txt


==================
What is installed?
==================

Examples using `bashcmd`.
All examples just display text.


::

   dockrun_t3rd bashcmd  ls -la /bin
   dockrun_t3rd bashcmd  ls -la /usr/bin
   dockrun_t3rd bashcmd  ls -la "\$\(pipenv --venv\)"/bin


::

   dockrun_t3rd bashcmd  ls -la "\$\(pipenv --venv\)"/bin
   dockrun_t3rd bashcmd  pipenv --venv
   dockrun_t3rd bashcmd  pipenv


::

   dockrun_t3rd bashcmd  python --help
   dockrun_t3rd bashcmd  python --version
   dockrun_t3rd bashcmd  sphinx-build --help
   dockrun_t3rd bashcmd  sphinx-build --version
   dockrun_t3rd bashcmd  sphinx-quickstart --help
   dockrun_t3rd bashcmd  sphinx-quickstart --version
   dockrun_t3rd bashcmd  tct



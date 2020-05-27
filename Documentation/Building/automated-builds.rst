.. include:: /Includes.rst.txt
.. highlight:: text


================
Automated builds
================

... are available from Docker hub.


Labelled build like v2.3.0: tested, stable, recommended, will not change.

From master: May be more advanced than labelled build, should work, may change.

From branche develop: Most advanced, will change, may have problems.



How to use 'develop'
--------------------

.. tip::

   Development builds are available now::

      # always try this update pull
      docker pull t3docs/render-documentation:develop

      # see what real tag is shown, for example v2.3.0-develop
      docker run --rm t3docs/render-documentation:develop

      # remove existing one
      docker rmi t3docs/render-documentation:v2.3.0-develop

      # rename to create the proper tag
      docker tag t3docs/render-documentation:develop \
                 t3docs/render-documentation:v2.3.0-develop

      # save shell commands
      docker run --rm \
         t3docs/render-documentation:v2.3.0-develop \
         show-shell-commands \
         > ~/.docker-shell-commands.sh

      # define dockrun_t3rd. Add this line to ~/.bashrc?
      source ~/.docker-shell-commands.sh

      # use it
      dockrun_t3rd



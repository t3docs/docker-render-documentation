.. include:: /Includes.rst.txt


======================
The 'dockrun' function
======================


Show function definition
========================

① For example, Ubuntu 18.04::

   # define the function
   source <(docker run --rm t3docs/render-documentation:v2.3.0 show-shell-commands)

Looks like:

.. code-block:: text

   ➜  ~ source <(docker run --rm t3docs/render-documentation:v2.3.0 show-shell-commands)
   This function is now defined FOR THIS terminal window to run v2.3.0:
       dockrun_t3rd

   ➜  ~


② Show the function definition::

   declare -f dockrun_t3rd

Looks like:

.. code-block:: shell

   ➜  ~ declare -f dockrun_t3rd
   dockrun_t3rd () {
      local DEBUG=${T3DOCS_DEBUG:-0}
      local DRY_RUN=${T3DOCS_DRY_RUN:-0}
      local git_restore_mtime=$(which git-restore-mtime)
      local exitcode=$?

   # [... much more ...]

      if (($DEBUG || $DRY_RUN))
      then
         echo $cmd | sed "s/-v /\\\\\\n   -v /g"
      fi
      if [[ "$DRY_RUN" = "0" ]]
      then
         eval "$cmd"
      fi
   }

   ➜  ~


Show constructed Docker command
===============================

`T3DOCS_DEBUG=0` is the default::

   ➜  ~ dockrun_t3rd
   t3rd - TYPO3 render documentation (v2.3.0)
   For help:
      docker run --rm t3docs/render-documentation:v2.3.0 --help
      dockrun_t3rd --help

   ... did you mean 'dockrun_t3rd makehtml'?

   See manual (draft) at
   https://docs.typo3.org/m/typo3/t3docs-docker-render-documentation/draft/en-us/



`T3DOCS_DEBUG=1` displays what values are being used::

   ➜  ~ T3DOCS_DEBUG=1  dockrun_t3rd
   PROJECT......: /home/marble
   creating: mkdir -p /home/marble/Documentation-GENERATED-temp
   RESULT.......: /home/marble/Documentation-GENERATED-temp
   OUR_IMAGE....: t3docs/render-documentation:v2.3.0
   docker run --rm --user=1000:1000 \
      -v /home/marble:/PROJECT:ro \
      -v /home/marble/Documentation-GENERATED-temp:/RESULT t3docs/render-documentation:v2.3.0
   t3rd - TYPO3 render documentation (v2.3.0)
   For help:
      docker run --rm t3docs/render-documentation:v2.3.0 --help
      dockrun_t3rd --help

   ... did you mean 'dockrun_t3rd makehtml'?

   See manual (draft) at
   https://docs.typo3.org/m/typo3/t3docs-docker-render-documentation/draft/en-us/

   ➜  ~


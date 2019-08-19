.. include:: ../Includes.txt


==================
Run parameters
==================

Due to development history there are lots of places from where parameters are
picked up.

Fortunately beginning with v2.3.0 you can now pass most parameter in one place.
The solution is a json "jobfile" you can provide. But for convenience and
self-explanation let's call it 'jobfile.json'.

Pass the absolute or relative path to that file as "run parameter" "jobfile"
on the commandline::

   dockrun_t3rd  makehtml  -c jobfile /PROJECT/jobfile.json

.. attention::

   The jobfile.json path must be given as it appears IN THE CONTAINER.

This means: Place it somewhere into your project to find it in the container
in /PROJECT or place it in Documentation-GENERATED-tmp to find it in /RESULT.


jobfile.json needs to be an array. It can be as simple - and useless - as `{}`.

Several keys have a meaning and need to be an array. Let's call these
a "section".

.. code-block:: json

   {
      "Overrides_cfg": {
         "comment": "data in this section goes into conf.py"
      },
      "tctconfig": {
         "comment": "data in this section controls how the toolchain behaves"
      },
      "buildsettings_sh": {
         "comment": "Data in the section can override the 16 settings that used to be in MAKEDIR/buildsettings.sh"
      }
   }

((to be continued))

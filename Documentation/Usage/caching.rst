.. include:: /Includes.rst.txt

=================
SPEED and caching
=================

Navigate this page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top


############################
2020-05-26, container v2.6.1
############################

Rendering times example
=======================

For 'sysext:core', the TYPO3 CMS changelog. Machine: Ubuntu 18.04 with SSD.
Read the following chapter for explanation. Follow-up runs are making use of
the Sphinx cache.

========== ================== ============= =========== =========== =========
run        what               allow_unsafe  seconds     minutes     remarks
========== ================== ============= =========== =========== =========
initial    makehtml-no-cache  0 (false)     2,730       45.5
follow-up  makehtml           0 (false)       719       12.0        mostly due to html post-processing
initial    makehtml-no-cache  1 (true)      2,049       34.2        no postprocessing
follow-up  makehtml           1 (true)      **25 (!)**   < 1.0 (!)
\          \+singlehtml                     +20
\          \+latex                          +60
\          \+package                        +37
========== ================== ============= =========== =========== =========


How to quickly render 'sysext:core', the TYPO3 CMS changelog
============================================================

Use `git_restore_mtime` set the file mtime to the date of their last commit.
This garantees stable file times which are required by Sphinx to enable
caching. It is a commandline program and may require the `--force` option or
an empty workdir. It is a good idea to run that program when the workdir is
clean. See `git_restore_mtime --help`.

Do the initial rendering. Initial means, either remove the cache
`:file:`Documentation-GENERATED-temp/Cache` manually or use the
`makehtml-no-cache` action.

A follow-up rendering is considerably faster. Note that Sphinx is checking
for several theme options whether the follow-up rendering has the same options.
If not, Sphinx caching is disabled and you end up whith the initial rendering
again.

*Example:*

Process everything as on Bamboo

`dockrun makehtml-no-cache`
   Took 2,730 seconds ≈ 45.5 minutes for the initial run.

`dockrun_t3rd makehtml`
   Took 719 seconds ≈ 12.0 minutes for the follow-up run.
   This is due mostly to the html postprocessing.

*Example:*

Render locally for personal use

`dockrun makehtml-no-cache -c allow_unsafe 1`
   Took 2,049 seconds ≈ 34.2 minutes for the initial run.

`dockrun_t3rd makehtml -c allow_unsafe 1`
   Took 25 seconds (!) for the follow-up run.


.. attention::

   Pitfall!

   Caching does not work when selected theme options change. If you do::

      # initial run
      dockrun makehtml-no-cache

      # follow-up run
      dockrun_t3rd makehtml -c allow_unsafe 1

   then the follow-up doesn't use the cache because the Sphinx rendering
   options are different.






################
2019-10-25
################


Why?
====

Caching can speed up html rendering by factor 100. For huge manuals this can
become crucial.


How does caching work?
======================

…

Caching can speed up 'html' building very much (factor 100 or so). If there are
many output files they don't have to be rewritten.

'makehtml-no-cache' removes existing cache data prior to working but always
recreates it during the 'html' build. The same is true for 'makeall-no-cache'.

The other builders always try to reuse the html-cache. They usually have to
rewrite all their output so the time needed for writing doesn't change.



Working with repositories
=========================

File modification times (mtime) aren't stable. That's normal.

Sphinx checks mtimes to decide about validity of cache data.

Cure::

   # if script git-restore-mtime exists and '*make*' in args try the command
   # See README: get 'git-restore-mtime' from https://github.com/MestreLion/git-tools
   if [[ "$git_restore_mtime" != "" ]] && [[ $@ =~ .*make.* ]]; then
      if (($DEBUG)); then
         echo $git_restore_mtime
         $git_restore_mtime
      else
         $git_restore_mtime 2>/dev/null
      fi
   fi

It's a tool packaged into Debian. Run `git_restore_mtime --help`.

Example: sysext:core
====================

What is shown below:

* An initial `makeall` "took 1914.98 seconds". That is about 32 minutes.
* A second run using the cache "took 125.35 seconds". That is about 2 minutes.
* A second run with just `makehtml` "took 11.83 seconds" - let's say 12 seconds.


Initial 'makeall' without cache (32 minutes)
--------------------------------------------


Remove all previous cache and build all::

   ➜  ~ cd ~/Repositories/git.typo3.org/Packages/TYPO3.CMS.git/typo3/sysext/core
   ➜  core git:(master) git pull

   ➜  core git:(master) dockrun_t3rd makeall-no-cache

   ==================================================
   10-Toolchain-actions/run_01-Start-with-everything.py
   exitcode:   0            41 ms


   [...]


   ==================================================
      18-Make-and-build/40-Html/run_40-Make-html.py
      exitcode:   0       1793583 ms

   ==================================================
      18-Make-and-build/41-Singlehtml/run_41-Make-singlehtml.py
      exitcode:   0         17814 ms

   ==================================================
      18-Make-and-build/42-Latex/run_42-Make-Latex.py
      exitcode:   0         62932 ms


   [...]


   ==================================================
      22-Assemble-results/run_13-Create-package.py
      exitcode:   0         29509 ms


   [...]


   ==================================================
      90-Finish/run_10-Say-goodbye.py

   project : 0.0.0 : Makedir
      makedir /ALL/Makedir
      2019-08-18 17:20:14 065035,  took: 1914.98 seconds,  toolchain: RenderDocumentation
      REBUILD_NEEDED because of change,  age 435041.9 of 168.0 hours,  18126.7 of 7.0 days
      OK: buildinfo, html, package, singlehtml

      exitcode:   0            42 ms

   ==================================================


   [...]


   Find the results:
     ./Documentation-GENERATED-temp/Result/project/0.0.0/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/singlehtml/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo/warnings.txt
     ./Documentation-GENERATED-temp/Result/latex/run-make.sh
     ./Documentation-GENERATED-temp/Result/package/package.zip



Second run 'makeall' using the cache (2 minutes)
------------------------------------------------

"took: 125.35 seconds", that is about 2 minutes (not 32)!

Render all using the cache::

   ➜  core git:(master) dockrun_t3rd  makeall

   ==================================================
   10-Toolchain-actions/run_01-Start-with-everything.py
   exitcode:   0            41 ms


   [...]


   ==================================================
      18-Make-and-build/40-Html/run_40-Make-html.py
      exitcode:   0          4836 ms

   ==================================================
      18-Make-and-build/41-Singlehtml/run_41-Make-singlehtml.py
      exitcode:   0         17560 ms

   ==================================================
      18-Make-and-build/42-Latex/run_42-Make-Latex.py
      exitcode:   0         62567 ms


   [...]


   ==================================================
      22-Assemble-results/run_13-Create-package.py
      exitcode:   0         31088 ms


   [...]


   ==================================================
      90-Finish/run_10-Say-goodbye.py

   project : 0.0.0 : Makedir
      makedir /ALL/Makedir
      2019-08-18 20:20:46 671706,  took: 125.35 seconds,  toolchain: RenderDocumentation
      REBUILD_NEEDED because of change,  age 435044.4 of 168.0 hours,  18126.8 of 7.0 days
      OK: buildinfo, html, package, singlehtml

      exitcode:   0            45 ms

   ==================================================


   [...]


   Find the results:
     ./Documentation-GENERATED-temp/Result/project/0.0.0/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/singlehtml/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo/warnings.txt
     ./Documentation-GENERATED-temp/Result/latex/run-make.sh
     ./Documentation-GENERATED-temp/Result/package/package.zip


Second run 'makehtml' using the cache (12 seconds)
--------------------------------------------------

...



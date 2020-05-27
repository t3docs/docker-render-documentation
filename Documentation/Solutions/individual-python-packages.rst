.. include:: /Includes.rst.txt


====================
PDF-generation
====================

Compare with
https://www.sphinx-doc.org/en/master/usage/builders/index.html#sphinx.builders.latex.LaTeXBuilder

.. contents:: This page
   :backlinks: top
   :class: compact-list
   :depth: 3
   :local:


Using texlive installed on Linux or Mac
=======================================

1. Install `texlive` locally on your machine::

      sudo apt-get \
         latexmk \
         texlive \
         texlive-fonts-recommended \
         texlive-latex-extra \
         texlive-latex-recommended

   Alternatively find a texlive Docker container to do the job. And don't
   forget to report back to here what you have found.


2. Create latex output from your project::

      dockrun_t3rd  makeall

   or::

      dockrun_t3rd  makehtml  -c make_latex 1

   The container automatically adds TYPO3-specific resources. The usual result
   file is PROJECT.tex. The container automatically make a copy named
   PROJECT.typo3.tex and does some replacements.


3. Run `run-make.sh` (rather fast)::

      Documentation-GENERATED-temp/Result/latex/run-make.sh


   This should produce a pdf file named `PROJECT.pdf` and a second one named
   `PROJECT.typo3.pdf`. The second one should have some TYPO3-specific colors
   and layout features.


Example listings
----------------

After `make_latex`::

   ➜  project ls -la ./Documentation-GENERATED-temp/Result/latex/
   insgesamt 212
   drwxr-xr-x 3 marble marble  4096 Aug 15 13:42 .
   drwxr-xr-x 4 marble marble  4096 Aug 15 09:26 ..
   -rw-r--r-- 1 marble marble  8888 Aug 15 11:40 footnotehyper-sphinx.sty
   -rw-r--r-- 1 marble marble   683 Aug 15 11:40 latexmkjarc
   -rw-r--r-- 1 marble marble   405 Aug 15 13:42 latexmkrc
   -rw-r--r-- 1 marble marble 18693 Aug 15 11:40 LatinRules.xdy
   -rw-r--r-- 1 marble marble  4366 Aug 15 11:40 LICRcyr2utf8.xdy
   -rw-r--r-- 1 marble marble 10189 Aug 15 11:40 LICRlatin2utf8.xdy
   -rw-r--r-- 1 marble marble   473 Aug 15 13:42 make.bat
   -rw-r--r-- 1 marble marble  1648 Aug 15 13:42 Makefile
   -rw-r--r-- 1 marble marble  2639 Aug 15 13:42 PROJECT.tex
   -rw-r--r-- 1 marble marble  2637 Aug 15 13:42 PROJECT.typo3.tex
   -rw-r--r-- 1 marble marble   392 Aug 15 11:40 python.ist
   -rwxr-xr-x 1 marble marble   234 Aug 15 13:42 run-make.sh
   -rw-r--r-- 1 marble marble  8137 Aug 15 13:42 sphinxhighlight.sty
   -rw-r--r-- 1 marble marble  2696 Aug 15 11:40 sphinxhowto.cls
   -rw-r--r-- 1 marble marble  3622 Aug 15 11:40 sphinxmanual.cls
   -rw-r--r-- 1 marble marble 14618 Aug 15 11:40 sphinxmulticell.sty
   -rw-r--r-- 1 marble marble 76220 Aug 15 11:40 sphinx.sty
   -rw-r--r-- 1 marble marble  8132 Aug 15 11:40 sphinx.xdy
   drwxr-xr-x 4 marble marble  4096 Aug 15 11:11 texmf_typo3

  ➜  project

After `run-make.sh`::

   ➜  project ls -la ./Documentation-GENERATED-temp/Result/latex/
   insgesamt 512
   drwxr-xr-x 3 marble marble  4096 Aug 15 13:45 .
   drwxr-xr-x 4 marble marble  4096 Aug 15 09:26 ..
   -rw-r--r-- 1 marble marble  8888 Aug 15 11:40 footnotehyper-sphinx.sty
   -rw-r--r-- 1 marble marble   683 Aug 15 11:40 latexmkjarc
   -rw-r--r-- 1 marble marble   405 Aug 15 13:42 latexmkrc
   -rw-r--r-- 1 marble marble 18693 Aug 15 11:40 LatinRules.xdy
   -rw-r--r-- 1 marble marble  4366 Aug 15 11:40 LICRcyr2utf8.xdy
   -rw-r--r-- 1 marble marble 10189 Aug 15 11:40 LICRlatin2utf8.xdy
   -rw-r--r-- 1 marble marble   473 Aug 15 13:42 make.bat
   -rw-r--r-- 1 marble marble  1648 Aug 15 13:42 Makefile
   -rw-rw-r-- 1 marble marble  1030 Aug 15 13:45 PROJECT.aux
   -rw-rw-r-- 1 marble marble 15197 Aug 15 13:45 PROJECT.fdb_latexmk
   -rw-rw-r-- 1 marble marble 16214 Aug 15 13:45 PROJECT.fls
   -rw-rw-r-- 1 marble marble     0 Aug 15 13:45 PROJECT.idx
   -rw-rw-r-- 1 marble marble   296 Aug 15 13:45 PROJECT.ilg
   -rw-rw-r-- 1 marble marble     0 Aug 15 13:45 PROJECT.ind
   -rw-rw-r-- 1 marble marble 50206 Aug 15 13:45 PROJECT.log
   -rw-rw-r-- 1 marble marble   129 Aug 15 13:45 PROJECT.out
   -rw-rw-r-- 1 marble marble 41872 Aug 15 13:45 PROJECT.pdf
   -rw-r--r-- 1 marble marble  2639 Aug 15 13:42 PROJECT.tex
   -rw-rw-r-- 1 marble marble    94 Aug 15 13:45 PROJECT.toc
   -rw-rw-r-- 1 marble marble  1030 Aug 15 13:45 PROJECT.typo3.aux
   -rw-rw-r-- 1 marble marble 16548 Aug 15 13:45 PROJECT.typo3.fdb_latexmk
   -rw-rw-r-- 1 marble marble 16987 Aug 15 13:45 PROJECT.typo3.fls
   -rw-rw-r-- 1 marble marble     0 Aug 15 13:45 PROJECT.typo3.idx
   -rw-rw-r-- 1 marble marble   314 Aug 15 13:45 PROJECT.typo3.ilg
   -rw-rw-r-- 1 marble marble     0 Aug 15 13:45 PROJECT.typo3.ind
   -rw-rw-r-- 1 marble marble 53199 Aug 15 13:45 PROJECT.typo3.log
   -rw-rw-r-- 1 marble marble   129 Aug 15 13:45 PROJECT.typo3.out
   -rw-rw-r-- 1 marble marble 48453 Aug 15 13:45 PROJECT.typo3.pdf
   -rw-r--r-- 1 marble marble  2637 Aug 15 13:42 PROJECT.typo3.tex
   -rw-rw-r-- 1 marble marble    94 Aug 15 13:45 PROJECT.typo3.toc
   -rw-r--r-- 1 marble marble   392 Aug 15 11:40 python.ist
   -rwxr-xr-x 1 marble marble   234 Aug 15 13:42 run-make.sh
   -rw-r--r-- 1 marble marble  8137 Aug 15 13:42 sphinxhighlight.sty
   -rw-r--r-- 1 marble marble  2696 Aug 15 11:40 sphinxhowto.cls
   -rw-r--r-- 1 marble marble  3622 Aug 15 11:40 sphinxmanual.cls
   -rw-r--r-- 1 marble marble 14618 Aug 15 11:40 sphinxmulticell.sty
   -rw-r--r-- 1 marble marble 76220 Aug 15 11:40 sphinx.sty
   -rw-r--r-- 1 marble marble  8132 Aug 15 11:40 sphinx.xdy
   drwxr-xr-x 4 marble marble  4096 Aug 15 11:11 texmf_typo3

   ➜  project


Using texlive Docker container
==============================

Using thomasweise/docker-texlive-full::

   cd ~/project

   mkdir -p Documentation-GENERATED-temp

   docker run --rm \
         -v $(pwd):/PROJECT:ro \
         -v $(pwd)/Documentation-GENERATED-temp:/RESULT \
         t3docs/render-documentation:develop \
         makeall -c jobfile /PROJECT/Documentation/jobfile.json

   docker run --rm \
         -v $(pwd)/Documentation-GENERATED-temp/Result/latex:/RESULT \
         --workdir="/RESULT/" \
         thomasweise/docker-texlive-full:latest \
         "./run-make.sh"


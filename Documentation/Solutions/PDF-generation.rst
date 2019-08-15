.. include:: ../Includes.txt


====================
PDF-generation
====================

Compare with
https://www.sphinx-doc.org/en/master/usage/builders/index.html#sphinx.builders.latex.LaTeXBuilder


Tested for Linux and Mac
========================

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


3. Run `run-make.sh`::

      cd Documentation-GENERATED-Result/Result/latex
      ./run-make.sh

   This should produce a pdf file named `PROJECT.pdf` and a second one named
   `PROJECT.typo3.pdf`. The second one should have some TYPO3-specific colors
   and layout features.

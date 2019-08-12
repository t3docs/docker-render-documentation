
===========
texmf_typo3
===========

This is a (hopefully) ready to run version of
https://github.com/TYPO3-Documentation/latex.typo3

It was created on Ubuntu 18.04 with `texlive` installed::

   # Linux, Ubuntu 18.04
   apt-get install \
      latexmk \
      texlive \
      texlive-fonts-recommended \
      texlive-latex-extra \
      texlive-latex-recommended


The build recipe of this folder `texmf_typo3`
=============================================

1. Download https://github.com/TYPO3-Documentation/latex.typo3/archive/v1.1.0.zip

2. Unpack and cd to `latex.typo3/font/`

3. In `convert-share-without-sudo.sh` change `INSTALL=1` to `INSTALL=0` and
   run `./convert-share-without-sudo.sh`. A folder `texmf` should appear.

4. Copy `typo3.sty` and `typo3_logo_color.png` into that folder.

5. Rename `texmf` to `texmf_typo3` and add this README, et voilà: This should
   be what we have here and is part of the Docker build.


Usage
=====

The Docker container is able to `make_latex`. It will add this `texmf_typo3`
folder to the `make_latex_result` folder.

The container cannot create PDFs, as this would require a much (>2GB) larger
container. So you have to do that step yourself. Either install `texlive`
in you system or find a Docker container that is able to do this step.

To make use of the `texmf_typo3` folder you have to tell the pdf builder where
to find this stuff. You can do this like so::

   # in the container's LaTeX result folder point to the `texmf_typo3`
   # subfolder and run make to build the PDF(s)
   TEXINPUTS=::texmf_typo3  make


End of README.

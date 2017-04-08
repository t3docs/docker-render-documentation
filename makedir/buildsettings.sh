# Source: https://docs.typo3.org/~mbless/github.com/TYPO3-Documentation/TYPO3/Book/ExtbaseFluid.git.make/buildsettings.sh
# buildsettings.sh

# absolute path, or relative to conf.py, without suffix (.rst)
MASTERDOC= /tmp/makedir/Documentation/Index.rst

# absolute path, or relative to conf.py
LOGDIR=.

PROJECT=t3extbasebook
VERSION=latest

# Where to publish documentation
BUILDDIR= /tmp/makedir/build

# If GITURL is empty then GITDIR is expected to be "ready" to be processed
# GITURL=https://github.com/TYPO3-Documentation/TYPO3CMS-Book-ExtbaseFluid.git
GITURL=
GITDIR= /tmp/makedir
GITBRANCH=latest

# Path to the documentation within the Git repository
T3DOCDIR= $GITDIR/Documentation

# Packaging information
PACKAGE_ZIP=0
PACKAGE_KEY=typo3cms.reference.ExtbaseBook
PACKAGE_LANGUAGE=default

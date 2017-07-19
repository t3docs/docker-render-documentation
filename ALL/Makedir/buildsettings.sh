# buildsettings.sh

# we assume 'docker run -v MyProject/Documentation:/tmp/T3DOCDIR t3docs/render-documentation"
# absolute path, or relative to conf.py, without suffix (.rst)
MASTERDOC=/PROJECT/Documentation/Index.rst

# absolute path, or relative to conf.py
# legacy setting. not used any more.
LOGDIR=.

PROJECT=Project
VERSION=0.0.0

# Where to publish documentation
# BUILDDIR=/RESULT
BUILDDIR=/ALL/dummy_webroot/typo3cms/project/0.0.0

# If GITURL is empty then GITDIR is expected to be "ready" to be processed
# GITURL=https://github.com/TYPO3-Documentation/TYPO3CMS-Book-ExtbaseFluid.git
GITURL=
GITDIR=/PROJECT
GITBRANCH=master

# Path to the documentation within the Git repository
T3DOCDIR=/PROJECT/Documentation

# Packaging information
PACKAGE_ZIP=0
PACKAGE_KEY=
PACKAGE_LANGUAGE=default

TER_EXTENSION=0
LOCALIZATION=default

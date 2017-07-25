#!/usr/bin/env bash
# update-conf-py-of-Makedir.sh

src=https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/conf-2015-10.py
destdir="$PWD"/../ALL-for-build/Makedir
dest=$destdir/conf.py

echo Updating "$dest"
wget $src --output-document "$dest"

chmod -R o+w $destdir

echo Contents of
echo "   $destdir"
ls -la $destdir


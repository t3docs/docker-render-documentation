#!/usr/bin/env bash
# update-_htaccess-of-Makedir.sh

src=https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/config/_htaccess-2016-08.txt
destdir="$PWD"/../ALL-for-build/Makedir
dest=$destdir/_htaccess

echo Updating "$dest"
wget $src --output-document "$dest"

chmod -R o+w $destdir

echo Contents of
echo "   $destdir"
ls -la $destdir

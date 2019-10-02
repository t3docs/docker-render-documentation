.. include:: /Includes.rst.txt


======================================================
Decode Sphinx Crossrefencing Inventories 'objects.inv'
======================================================

.. contents:: This page
   :backlinks: top
   :class: compact-list
   :depth: 3
   :local:


What is this about?
===================

Most Sphinx documentation projects offer an inventory of linktargets in a file
named :file:`objects.inv`. It is usually locate in the root folder and can be
downloaded via `https://www.project-domain.tld/objects.inv`.
`TYPO3 CMS Core ChangeLog documentation
<https://docs.typo3.org/c/typo3/cms-core/master/en-us/>`__ has such an
inventory: https://docs.typo3.org/c/typo3/cms-core/master/en-us/objects.inv
The purpose of such an inventory is to allow symbolic linking from another
Sphinx project which is unknown to the target. The Sphinx "Intersphinx"
mechanism provides that possibility. To use that in an arbitrary Sphinx project
you define an "intersphinx mapping", which could be `t3changelog =
https://docs.typo3.org/c/typo3/cms-core/master/en-us/` in this case. Afterwards
you can pick one of the target labels and link to that spot in the changelog
manual without caring about actual urls. And, if the authors of the changelog
decide to move things around your link will still be valid once your manual
received a new rendering".





## For freaks only

### Example
Q: How do I know whether there is a label containing '75625' in the core changelog?

A: The docker container can give us that answer:
```
➜  docker run --rm -t --entrypoint /bin/bash t3docs/render-documentation:v2.2.6 -c "pipenv run python -m sphinx.ext.intersphinx https://docs.typo3.org/c/typo3/cms-core/master/en-us/objects.inv" | grep 75625
	Changelog/8.1/Deprecation-75625-DeprecatedCacheClearingOptions Deprecation: #75625 - Deprecated cache clearing options: Changelog/8.1/Deprecation-75625-DeprecatedCacheClearingOptions.html

➜  # So the answer is: Changelog/8.1/Deprecation-75625-DeprecatedCacheClearingOptions Deprecation
```

### Explanation
What's going on here?

`docker run t3docs/render-documentation:v2.2.6`
We run our Docker container.

`--rm`
We want that container removed right afterwards.

`-t`
We connect the output to our terminal.

`--entrypoint /bin/bash`
We specify the bash as shell. Don't put the command to execute here!

`-c`
For the bash we specify that the following is a command to be executed.

`pipenv run python`
Inside the container `/ALL/venv` is our current folder. A Python virtual environment is prepared in the container, but it isn't activated. `pipenv run EXECUTABLE` can start an executable of that environment. We want to start `python`.

`-m sphinx.ext.intersphinx`
We run the intersphinx module as a "__main__" program. For that case the module provides code that can do a very simple dump of an link inventory. Not great, but works.
Read about this in the Sphinx docs: [Showing all links of an Intersphinx mapping file](https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html#showing-all-links-of-an-intersphinx-mapping-file)

`https://docs.typo3.org/c/typo3/cms-core/master/en-us/objects.inv`
This is the inventory we want to have downloaded and queried. In TYPO3 we are following the usual convention that it's named `objects.inv` and located in the root path of a manual.

`| grep 75625`
We pipe the output through `grep` and watch out for lines containing `75625`.

It seems that the first word is the desired label.

### About the inventory
Watch out: There are at least two lists of labels. One is for `:doc:…` linking and one is for `:ref:…`linking.

## Idea
It should be easy to add a function to our container that produces a proper json dump of such inventories.

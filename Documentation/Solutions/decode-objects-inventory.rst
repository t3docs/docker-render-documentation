.. include:: ../Includes.rst.txt

========================================================
Decode Sphinx Crossreferencing Inventories 'objects.inv'
========================================================

.. contents:: This page
   :backlinks: top
   :class: compact-list
   :depth: 3
   :local:

See also: `TYPO3CMS-Guide-HowToDocument/issues/110
<https://github.com/TYPO3-Documentation/TYPO3CMS-Guide-HowToDocument/issues/110>`__

What is this about?
===================

Most Sphinx documentation projects offer an inventory of link targets in a file
named :file:`objects.inv`. It is usually locate in the root folder and can be
downloaded via `https://www.project-domain.tld/objects.inv`.
`TYPO3 CMS Core ChangeLog documentation
<https://docs.typo3.org/c/typo3/cms-core/master/en-us/>`__ has such an
inventory: https://docs.typo3.org/c/typo3/cms-core/master/en-us/objects.inv
The purpose of such an inventory is to allow symbolic linking from another
Sphinx project. Note that the target documentation has no idea about who in the
world is linking to it. The Sphinx "Intersphinx"
mechanism provides that possibility. To use that in an arbitrary Sphinx project
you define an "intersphinx mapping", which could be `t3changelog =
https://docs.typo3.org/c/typo3/cms-core/master/en-us/` in this case. Afterwards
you can pick one of the target labels and link to that spot in the changelog
manual without caring about URLs. And, if the authors of the changelog
decide to move things around your link will still be valid once your manual
received a new rendering". A link to a target would be written as::

   :ref:`t3changelog:THE-LABEL`

The amazing thing is, that the link text, that is shown, automatically will be
that of the headline in the destination manual.


What link targets are there?
============================

In order create a reference to a spot in another manual you need to know about
the possible link targets. And that may be a problem, if the target site
doesn't make obvious what targets exist.
The solution sounds easy and would be: "Have a look into the other manual's
:file:`objects.inv` file. But that's a problem: it is a binary file.


How to decode `objects.inv`?
============================

Sphinx know how to decode and read that file. So let's directly use Sphinx for
that purpose.
Read about this in the Sphinx docs:
`Showing all links of an Intersphinx mapping file
<https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html#showing-all-links-of-an-intersphinx-mapping-file)>`__

Here is a sample command that does the trick::

   OBJECTS_INV_URL=https://docs.typo3.org/c/typo3/cms-core/master/en-us/objects.inv
   # set one IMAGE_TAG
   IMAGE_TAG=v2.3.0
   IMAGE_TAG=latest
   IMAGE_TAG=develop
   docker run --rm -t --entrypoint /bin/bash \
      t3docs/render-documentation:$IMAGE_TAG \
      -c "pipenv run python -m sphinx.ext.intersphinx $OBJECTS_INV_URL"

   # Result is a long list in text format shown in the terminal.


What's going on here? Explanation:

`docker run t3docs/render-documentation:$IMAGE_TAG`
   We run our Docker container.

`--rm`
   We want to have that container removed right after finishing.

`-t`
   Connect the output to our tty (terminal).

`--entrypoint /bin/bash`
   We specify the bash as shell. Don't put the command to execute here!

`-c`
   For the bash we specify that the following is a command to be executed.

`pipenv run python`
   Inside the container :file:`/ALL/venv` is our current folder. A Python
   virtual environment is prepared in the container, but it isn't activated.
   `pipenv run EXECUTABLE` can start an executable of that environment.
   We want to start `python`.

`-m sphinx.ext.intersphinx`
   We run the intersphinx module as a "__main__" program. For that case the
   module provides code that can do a very simple dump of an link inventory.
   Not great, but works.



`https://docs.typo3.org/c/typo3/cms-core/master/en-us/objects.inv`
   This is the inventory we want to have downloaded and queried. In TYPO3 we
   are following the usual convention that it's named :file:`objects.inv` and
   is located in the root path of a manual.


About inventories
=================

Watch out: There are at least two lists of labels. One is for `:doc:…` linking
and one is for `:ref:…`linking.


Example: Looking for '75625'
----------------------------

Q: How do I know whether there is a label containing '75625' in the core
changelog?

A: The docker container can answer that::

   OBJECTS_INV_URL=https://docs.typo3.org/c/typo3/cms-core/master/en-us/objects.inv
   # set one IMAGE_TAG
   IMAGE_TAG=v2.3.0
   IMAGE_TAG=latest
   docker run --rm -t --entrypoint /bin/bash \
      t3docs/render-documentation:$IMAGE_TAG \
      -c "pipenv run python -m sphinx.ext.intersphinx https://docs.typo3.org/c/typo3/cms-core/master/en-us/objects.inv" \
      | grep 75625

Shows `Changelog/8.1/Deprecation-75625-DeprecatedCacheClearingOptions
Deprecation: #75625 - Deprecated cache clearing options:
Changelog/8.1/Deprecation-75625-DeprecatedCacheClearingOptions.html`

So the answer is: `Changelog/8.1/Deprecation-75625-DeprecatedCacheClearingOptions`

Now you can use this link::

   :doc:`t3changelog:Changelog/8.1/Deprecation-75625-DeprecatedCacheClearingOptions`

This target key is made up of: ⓐ url-mapping-key ⓑ ':' ⓒ relative path ⓓ
slug of the document title

The slug is [A-Za-z0-9-_] only. It is case sensitive but forgiving. That means,
Sphinx is looking for an exact match and if there isn't on it looks again,
this time case insensitive. The first title in a reST file is its document
title, which is transformed into the slug (=key). The document title of the
target page is used as link text in the created link:

.. figure:: files/decode-01.png
   :class: with-shadow

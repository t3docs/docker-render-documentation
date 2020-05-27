.. include:: /Includes.rst.txt


====================
Security
====================

1. The `.. include::` directive is enabled, but includes from outside the
   project are detected and prevent rendering.

2. The `.. raw::` directive is always turned off.

3. XSS is possible if not rendering for the server

   This is controlled by the html_theme_option['docstypo3'] = ''; # empty!

   For `<a href="..."` and `<img src="..."` there is a risk of cross-site-
   scripting. For local renderings this risk is given - be sure to know what.
   you are doing. Example of XSS that is usually not prevented by the
   container:

   .. code-block:: rst

      This `link <javascript:alert("hello word")>`__ executes Javascript

4. XSS is not possible when the rendering of the container is targeted to the
   server. This is controlled by the html_theme_option['docstypo3'] = 'somevalue';

   If this is the case postprocessing of all generated html files will be done
   that sanitized the html tags and replaces offensive values to '#' or ''.

.. versionadded:: > 2.5.1

   Since NEWER versions than 2.5.1 these four checks can be turned off by setting
   option `allow_unsafe = 1`. Example::

      dockrun_t3rd makehtml  -c allow_unsafe 1


Run
===

Run without sanitzing
---------------------

Create a json file named 'jobfile.json':

.. code-block:: json

   {
   "Overrides_cfg": {
     "html_theme_options": {
       "docstypo3org": ""
     }
   }

Run the build::

   dockrun_t3rd  makehtml  -c make_singlehtml  -c jobfile jobfile.json

Characteristics: xss not prevented, fast, leaves the Sphinx cache intact.


Run with sanitzing
------------------

Create a json file named 'jobfile.json':

.. code-block:: json

   {
   "Overrides_cfg": {
     "html_theme_options": {
       "docstypo3org": "yes"
     }
   }

Run the build::

   dockrun_t3rd  makehtml  -c make_singlehtml  -c jobfile jobfile.json

Characteristics: xss prevented, slower, interferes with part or all of Sphinx
caching.


Test data
=========


A sample readme file trying xss
-------------------------------

This code can be used for tests:

.. code-block:: rst

   ==========
   README.rst
   ==========

   The raw directive should be blocked. A warning should be in
   _buildinfo/warnings.txt:

   .. raw:: html

      This would be raw_text.


   Links and 'javascript:'
   =======================

   See https://hackerone.com/reports/205497

   .. _href-alert-1: javascript:alert(document.domain)

   1. href-alert-1_
   2. `href-alert-2 <href-alert-1_>`__
   3. `href-alert-3 <javascript:>`__
   4. href-alert-4__

   __  javascript:alert(document.domain)


   Links and 'data:'
   =================

   See https://www-archive.mozilla.org/quality/networking/testing/datatests.html

   1. href-data-1_
   2. `href-data-2 <href-data-2_>`__
   3. `href-data-3 <href-data-3_>`__
   4. `href-data-4 <href-data-4_>`__

   .. _href-data-1: data:,A%20brief%20note
   .. _href-data-2: data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7
   .. _href-data-3: data:text/plain;charset=iso-8859-7,%b8%f7%fe
   .. _href-data-4: data:text/plain;charset=iso-8859-8-i;base64,+ezl7Q==


   Images and 'javascript:'
   ========================

   .. image:: javascript:alert(document.domain)
      :alt: img-javascript-1
   .. image:: javascript:
      :alt: img-javascript-2


   Images and 'data:'
   ==================

   .. image:: data:,A%20brief%20note
      :alt: img-data-1
   .. image:: data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7
      :alt: img-data-2
   .. image:: data:text/plain;charset=iso-8859-7,%b8%f7%fe
      :alt: img-data-3
   .. image:: data:text/plain;charset=iso-8859-8-i;base64,+ezl7Q==
      :alt: img-data-4


Further verifications
=====================

If building succeeds there should be a _buildinfo/results.json file in the
output. This should show useful information regarding security.
Example (details may change):

.. code-block:: json

   {
     "created": {
       "html": 1,
       "singlehtml": 1
     },
     "has_neutralized_images": 1,
     "has_neutralized_links": 1,
     "postprocessed_html_files": 4,
     "sitemap_files_html_count": 4,
     "sitemap_files_singlehtml_count": 1,
   }



.. include:: ../Includes.txt


====================
Security
====================

1. The `.. include::` directory is enable, but includes from outside the
   project are prevented.

2. The `.. raw::` directive is always turned off.

3. XSS is possible if not rendering for the server

   This is controlled by the html_theme_option['docstypo3'] = ''; # empty!

   For `<a href="..."` and `<img src="..."` there is a risk of cross-site-
   scripting. For local renderings this risk is given - be sure to know what.
   you are doing. Example of XSS that is usually not prevented by the
   container:

   .. code-block:: rst

      This `link <javascript:alert("hello word")>`__ executes Javascript

4. XSS is not possible when the rendering of the container is targeted at the
   server. This is controlled by the html_theme_option['docstypo3'] = 'somevalue';

   If this is the case postprocessing of all generated html files will be done
   that sanitized the html tags and replaces offensive values to '#' or ''.






.. include:: /Includes.rst.txt


==============
Run parameters
==============

DRAFT • WIP • DRAFT • WIP • DRAFT • WIP • DRAFT • WIP • DRAFT • WIP •
DRAFT • WIP • DRAFT • WIP • DRAFT • WIP • DRAFT • WIP • DRAFT • WIP •
DRAFT • WIP • DRAFT • WIP • DRAFT • WIP • DRAFT • WIP • DRAFT • WIP •

.. versionadded:: v2.3.0

.. index:: jobfile_json

Due to development history there are lots of places from where parameters are
picked up.

Fortunately beginning with v2.3.0 you can now pass most parameters in one place.
The solution is a json "jobfile" you can provide. For convenience,
self-explanation and consistency let's always call it :file:`jobfile.json`.

Pass the absolute or relative path to that file as parameter `jobfile`
on the commandline::

   dockrun_t3rd  makehtml  -c jobfile /PROJECT/Documentation/jobfile.json

.. attention::

   The `jobfile.json` path must be given as it appears IN THE CONTAINER.

This means: Place it somewhere into your project to find it within the
container somewhere below /PROJECT. Another obvious place would be
`Documentation-GENERATED-tmp`, which means somewhere below /RESULT within the
container.

A minimum :file:`jobfile.json` file contains and empty array. It can be as
simple - and ineffective - as :js:`{}`.

.. highlight:: json

Several keys have a meaning and need to be an array. Let's call these
a "section"::

   {
      "Overrides_cfg": {
         "comment": "data in this section goes into conf.py"
      },
      "tctconfig": {
         "comment": "data in this section controls how the toolchain behaves"
      },
      "buildsettings_sh": {
         "comment": "Data in the section can override the 16 settings that used to be in MAKEDIR/buildsettings.sh"
      }
   }


Some interesting values filled in::

   {
      "Overrides_cfg": {

         "extensions": [
            "sphinx.ext.autodoc",
            "sphinx.ext.coverage",
            "sphinx.ext.extlinks",
            "sphinx.ext.ifconfig",
            "sphinx.ext.intersphinx",
            "sphinx.ext.mathjax",
            "sphinx.ext.todo",
            "sphinxcontrib.googlechart",
            "sphinxcontrib.googlemaps",
            "sphinxcontrib.phpdomain",
            "sphinxcontrib.slide",
            "sphinxcontrib.t3fieldlisttable",
            "sphinxcontrib.t3tablerows",
            "sphinxcontrib.t3targets",
            "sphinxcontrib.youtube",
            "t3SphinxThemeRtd"
         ],

         "extlinks": {
            "forge": [
               "https://forge.typo3.org/issues/%s",
               "Forge #"
            ],
            "issue": [
               "https://forge.typo3.org/issues/%s",
               "Issue #"
            ],
            "review": [
               "https://review.typo3.org/%s",
               "Review #"
            ]
         },

         "html_theme_options": {
            "add_piwik": "",
            "docstypo3org": "",
            "github_branch": "",
            "github_commit_hash": "",
            "github_repository": "",
            "github_revision_msg": "",
            "github_sphinx_locale": "",
            "path_to_documentation_dir": "",
            "project_contact": "",
            "project_discussions": "",
            "project_home": "",
            "project_issues": "",
            "project_repository": "",
            "show_copyright": "yes",
            "show_last_updated": "yes",
            "show_legalinfo": "",
            "show_revision": "yes",
            "show_sourcelink": "yes",
            "show_sphinx": "yes",
            "use_opensearch": ""
         },

         "intersphinx_mapping": {
         },

         "general": {
            "highlight_language": "php",
            "html_last_updated_fmt": "%b %d, %Y %H:%M",
            "html_show_copyright": true,
            "html_show_sourcelink": true,
            "html_show_sphinx": true,
            "html_static_path": [],
            "html_theme": "sphinx_rtd_theme",
            "html_theme_path": [
               "/ALL/userhome/.local/share/virtualenvs/venv-y0waPz_e/local/lib/python2.7/site-packages"
            ],
            "html_use_opensearch": "",
            "html_use_smartypants": false,
            "htmlhelp_basename": "t3shortname",
            "language": null,
            "latex_documents": [
               [
                  "Index",
                  "PROJECT.tex",
                  "The Project's Title",
                  "The Author(s)",
                  "manual"
               ]
            ],
            "latex_elements": {
               "papersize": "a4paper",
               "pointsize": "10pt",
               "preamble": "%%\\usepackage{typo3}"
            },
            "logdirabspath": "/ALL/Makedir/SYMLINK_THE_MAKEDIR",
            "man_pages": [
               [
                  "Index",
                  "The Project's Title",
                  "This is project 'The Project's Title'",
                  [
                     "The Author(s)"
                  ],
                  1
               ]
            ],
            "master_doc": "Index",

            "project": "The Project Title",
            "pygments_style": "sphinx",
            "release": "1.10.0",
            "source_suffix": [
              ".rst"
            ],
            "t3author": "The Author(s)",
            "t3shortname": "t3shortname",
            "templates_path": [],
            "texinfo_documents": [
               [
                  "Index",
                  "t3shortname",
                  "The Project's Title",
                  "The Author(s)",
                  "The Project's Title",
                  "This is project 'The Project's Title'",
                  "Miscellaneous"
               ]
            ],
            "today_fmt": "%Y-%m-%d %H:%M",
            "todo_include_todos": false,
            "version": "1.10"
         }
      },

      "tctconfig": {
         "activateLocalSphinxDebugging": 0,
         "disable_include_files_check": 0,
         "force_rebuild_needed": 1,
         "make_html": 1,
         "make_latex": 0,
         "make_pdf": 0,
         "make_singlehtml": 0,
         "rebuild_needed": 1,
         "replace_static_in_html": 0,
         "reveal_exitcodes": 1,
         "reveal_milestones": 1,
         "talk": 1,
         "try_pdf_build_from_published_latex": 0
      },
      "buildsettings_sh": {
      }
   }

((to be continued))


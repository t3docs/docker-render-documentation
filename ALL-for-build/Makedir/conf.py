# -*- coding: utf-8 -*-

# We have these sources of settings. Higher numbers take precedence.
# ATTENTION: Settings.json can do almost everything
#
# (1) MAKEDIR/buildsettings.sh                            (buildtime)
# (2) Hardcoded settings from this conf.py file           (buildtime)
# (3) Settings from MAKEDIR/Defaults.cfg                  (buildtime)
# (4) User settings from ./Documentation/Settings.cfg     (user)
# (5) More hardcoded settings from this conf.py file      (buildtime)
# (6) Settings from MAKEDIR/Overrides.cfg                 (buildtime)
# (7) Settings from Settings.json                         (operator at runtime)

import codecs
import json
import os
import toml
from os.path import exists as ospe, isabs, join as ospj, normpath, split as ospsplit

import six.moves.configparser
import sphinx_typo3_theme
from pygments.lexers.web import PhpLexer
# enable highlighting for PHP code not between <?php ... ?> by default
from sphinx.highlighting import lexers
try:
    from io import StringIO
except ImportError:
    from cStringIO import StringIO

__version__ = "2021-12-16_18-45"

lexers["php"] = PhpLexer(startinline=True)
lexers["php-annotations"] = PhpLexer(startinline=True)

CommonMarkParser = None
# CommonMarkParser turns Sphinx caching off.
# So we don't use it but use 'pandoc' in the toolchain.
if 0:
    try:
        from recommonmark.parser import CommonMarkParser
    except ImportError:
        CommonMarkParser = None

if CommonMarkParser:
    source_parsers = {".md": CommonMarkParser}
    source_suffix = [".rst", ".md"]
else:
    source_suffix = [".rst"]
#
#
#
#
# preparations
#
# the dictionary of variables of this module 'conf.py'
G = globals()
# where we merge the various settings
US = user_settings = {}


#
#
#
#
# (1) MAKEDIR/buildsettings.sh
#
section = "build"
config = six.moves.configparser.RawConfigParser()
f1name = "buildsettings.sh"
with codecs.open(f1name, "r", "utf-8") as f1:
    data = f1.read()
read_method = getattr(config, 'read_file', None) or getattr(config, 'readfp')
read_method(StringIO(u"[" + section + u"]\n" + data))

# Required:
MASTERDOC = config.get(section, "MASTERDOC")
BUILDDIR = config.get(section, "BUILDDIR")
GITDIR = config.get(section, "GITDIR")
LOGDIR = config.get(section, "LOGDIR")
MASTERDOC = config.get(section, "MASTERDOC")
T3DOCDIR = config.get(section, "T3DOCDIR")

# find absolute path to conf.py(c)
confpyabspath = None
try:
    confpyabspath = os.path.abspath(__file__)
except:
    import inspect

    confpyabspath = os.path.abspath(inspect.getfile(inspect.currentframe()))

confpyabspath = normpath(confpyabspath)
confpyfolder = ospsplit(confpyabspath)[0]

if isabs(MASTERDOC):
    masterdocabspath = normpath(MASTERDOC)
else:
    masterdocabspath = normpath(ospj(GITDIR, MASTERDOC))

if isabs(LOGDIR):
    logdirabspath = normpath(LOGDIR)
else:
    logdirabspath = normpath(ospj(confpyfolder, LOGDIR))

# the absolute path to ./Documentation/
projectabspath = ospj(GITDIR, T3DOCDIR)
# the absolute path to Documentation/Settings.cfg
settingsabspath = projectabspath + "/" + "Settings.cfg"
defaultsabspath = ospj(confpyfolder, "Defaults.cfg")
overridesabspath = ospj(confpyfolder, "Overrides.cfg")
# Makefile/Settings.json is the 'conf_py' part of jobfile.json
settingsjsonabspath = ospj(confpyfolder, "Settings.json")


def firstNotNone(*args):
    for a in args:
        if a is not None:
            return a
    return None

def get_list_of_strings_from_string(s):
    result = []
    s = s.strip()
    ok = s.startswith("[") and s.endswith("]")
    if ok:
        s = s[1:-1].strip()
        ok = not not s
    if ok:
        for part in s.split(','):
            part = part.strip()
            if part:
                ok = (
                    (part.startswith("'") and part.endswith("'"))
                    or
                    (part.startswith('"') and part.endswith('"'))
                )
                if not ok:
                    break
                result.append(part[1:-1])
    if not ok:
        result = []
    return result



def merge_settings_file(fpath, D):
    if not ospe(fpath):
        return
    config = six.moves.configparser.RawConfigParser()
    config.readfp(codecs.open(fpath, "r", "utf-8"))
    for s in config.sections():
        s2 = s.replace('-', '_')
        parts = s2.split('_')
        if parts[0] == 'docstypo3':
            D2 = D
            for part in parts:
                D2[part] = D2.get(part, {})
                D2 = D2[part]
            for o in config.options(s):
                D2[o] = config.get(s, o)
        else:
            D[s2] = D.get(s2, {})
            for o in config.options(s):
                D[s2][o] = config.get(s, o)

    v = D.get("general", {}).get("graphviz_dot_args", "")
    if v:
        del D["general"]["graphviz_dot_args"]
        v = get_list_of_strings_from_string(v)
    if v:
        D2 = D.get("graphviz_dot_args_as_dict", {})
        D["graphviz_dot_args_as_dict"] = D2
        for elm in v:
            parts = elm.split("=", 1)
            if len(parts) == 2:
                D2[parts[0]] = parts[1]

#
#
#
#
# (2) Hardcoded settings in this conf.py file
#
project = u"The Project's Title"
copyright = u"Since ever by authors and copyright holders"
t3shortname = u"t3shortname"
t3author = u"The Author(s)"
description = u""

version = "0.0"
release = "0.0.0"

html_theme = "sphinx_typo3_theme"
pygments_style = "none"

html_theme_options = {}
html_theme_options["github_branch"] = ""  # 'master'
html_theme_options[
    "github_commit_hash"
] = ""  # 'a2e479886bfa7e866dbb5bfd6aad77355f567db0'
html_theme_options[
    "github_repository"
] = ""  # 'TYPO3-Documentation/TYPO3CMS-Reference-Typoscript'
html_theme_options[
    "path_to_documentation_dir"
] = ""  # 'Documentation/' or e.g. 'typo3/sysext/form/Documentation/'
html_theme_options[
    "github_revision_msg"
] = ""  # '<a href="https://github.com/TYPO3-Documentation/EXAMPLE' + '/commit/' +'a2e479886bfa7e866dbb5bfd6aad77355f567db0' + '" target="_blank">' + 'a2e47988' + '</a>'
html_theme_options["github_sphinx_locale"] = ""  # deprecated, use t3docs_locale
html_theme_options["t3docs_locale"] = ""         # "" for en_US, "de_DE", "fr_FR", ...
html_theme_options["project_contact"] = ""  # 'mailto:documentation@typo3.org'
html_theme_options[
    "project_discussions"
] = ""  # 'http://lists.typo3.org/cgi-bin/mailman/listinfo/typo3-project-documentation'
html_theme_options["project_home"] = ""  # some url
html_theme_options[
    "project_issues"
] = ""  # 'https://github.com/TYPO3-Documentation/TYPO3CMS-Reference-Typoscript/issues'
html_theme_options[
    "project_repository"
] = ""  # 'https://github.com/TYPO3-Documentation/TYPO3CMS-Reference-Typoscript.git'

html_use_opensearch = ""  # like: 'https://docs.typo3.org/typo3cms/TyposcriptReference/0.0'  no trailing slash!

highlight_language = "php"
html_use_smartypants = False
language = None
master_doc = os.path.splitext(ospsplit(masterdocabspath)[1])[0]
todo_include_todos = False
exclude_patterns = []
nitpick_ignore_regex = [('py:.*', '.*'), ('php:.*', '.*'), ('std:class', '.*')]

# Keep in sync with Defaults.cfg:
extensions_to_be_loaded = [
    "sphinx.ext.autodoc",
    "sphinx.ext.coverage",
    "sphinx.ext.extlinks",
    "sphinx.ext.graphviz",
    "sphinx.ext.ifconfig",
    "sphinx.ext.intersphinx",
    "sphinx.ext.mathjax",
    "sphinx.ext.todo",
    "sphinx_copybutton",
    "sphinx_panels",
    "sphinx_tabs.tabs",
    "sphinx_typo3_theme",
    "sphinxcontrib.collections",
    "sphinxcontrib.docstypo3",
    "sphinxcontrib.gitloginfo",
    "sphinxcontrib.phpdomain",
    "sphinxcontrib.plantuml",
    "sphinxcontrib.slide",
    "sphinxcontrib.t3fieldlisttable",
    "sphinxcontrib.t3tablerows",
    "sphinxcontrib.t3targets",
    "sphinxcontrib.youtube",
]

# Legal extensions will be loaded if requested in Settings.cfg or Overrides.cfg
# Actually, this is not activated at the moment. Any (available) extension may
# be requested in Settings.cfg

legal_extensions = [
    # to be extended ...
]

# Extensions to be loaded are legal of course. Just be clear.
for e in extensions_to_be_loaded:
    if not e in legal_extensions:
        legal_extensions.append(e)

# make a copy (!)
extensions = extensions_to_be_loaded[:]

extlinks = {}
# extlinks["role"] = ("url/%s", "prefix")


# Graphviz styles
#
# Assign default attributes to graphs, nodes and edges by
#
# - -G<attribute=value>
# - -N<attribute=value> and
# - -E<attribute=value>.
#
# Find all attributes at https://graphviz.org/doc/info/attrs.html.
#
# Align with PlantUML styles.

# use dict so we can do overrides
graphviz_dot_args_as_dict = {}

# graphviz_dot_args_as_dict = {
#     "-Gcolor"     : "#000000",
#     "-Gfillcolor" : "#FFFFFF",
#     "-Gfontname"  : "sans-serif",
#     "-Gfontsize"  : "10.0",
#     "-Gfontcolor" : "#333333",
#     "-Nstyle"     : "filled",
#     "-Ncolor"     : "#A80036",
#     "-Nfillcolor" : "#FEFECE",
#     "-Nfontname"  : "sans-serif",
#     "-Nfontsize"  : "10.0",
#     "-Nfontcolor" : "#333333",
#     "-Ecolor"     : "#F49700",
#     "-Efontname"  : "sans-serif",
#     "-Efontsize"  : "9.0",
#     "-Efontcolor" : "#333333",
# }
#
# what we need in the end
# [general]
#graphviz_dot_args = [
#    "-Gcolor=#000000",
#    "-Gfillcolor=#FFFFFF",
#    "-Gfontname=sans-serif",
#    "-Gfontsize=10.0",
#    "-Gfontcolor=#333333",
#    "-Nstyle=filled",
#    "-Ncolor=#A80036",
#    "-Nfillcolor=#FEFECE",
#    "-Nfontname=sans-serif",
#    "-Nfontsize=10.0",
#    "-Nfontcolor=#333333",
#    "-Ecolor=#F49700",
#    "-Efontname=sans-serif",
#    "-Efontsize=9.0",
#    "-Efontcolor=#333333",
#]

# PlantUML stylesheet
plantumlfolder = ospj(confpyfolder, "sphinxcontrib-plantuml")
plantumlstylesabspath = ospj(plantumlfolder, "typo3_styles.iuml")
plantuml = ["plantuml", "-I" + plantumlstylesabspath]

intersphinx_mapping = {}
#
panels_add_bootstrap_css = False
#
#
#
#
# (3) Settings from MAKEDIR/Defaults.cfg
merge_settings_file(defaultsabspath, US)
#
#
#
#
# (4) User settings from ./Documentation/Settings.cfg
merge_settings_file(settingsabspath, US)
#
#
#
#
# (5) More hardcoded settings in this conf.py file
#
us_general = US["general"] = US.get("general", {})
if US.get("exclude_patterns") is None:
    US["exclude_patterns"] = {"anyname": "_make"}
us_general["html_last_updated_fmt"] = "%b %d, %Y %H:%M"
us_general["html_static_path"] = []
us_general["html_theme_path"] = ["_themes", sphinx_typo3_theme.get_html_theme_path()]
us_general["templates_path"] = []
us_general["today_fmt"] = "%Y-%m-%d %H:%M"

# 'published' means in the following context: Available under that name in the
# GlobalContext of Jinja2 templating. Example: if 'show_copyright' is said to
# be published it can be used in the Jinja2 template like:
#     {{ show_copyright }}

us_html_theme_options = US["html_theme_options"] = US.get("html_theme_options", {})

# no, not rendering for the server by default
us_html_theme_options["docstypo3org"] = False

# 'html_show_copyright' is published as 'show_copyright'
us_general["html_show_copyright"] = True

# published as 'theme_show_copyright'
us_html_theme_options["show_copyright"] = True

# published as 'theme_show_last_updated
us_html_theme_options["show_last_updated"] = True

# published as 'theme_show_revision'
us_html_theme_options["show_revision"] = True

# published as 'show_source'
us_general["html_show_sourcelink"] = True

# published as 'theme_show_sourcelink'
us_html_theme_options["show_sourcelink"] = True

# published as 'show_sphinx'
us_general["html_show_sphinx"] = True

# published as 'theme_show_sphinx'
us_html_theme_options["show_sphinx"] = True

# published as 'use_opensearch' (set above already)
# html_use_opensearch = html_use_opensearch
# '' is published as 'theme_use_opensearch
# no trailing slash!

# DISABLED here for now
if 1:
    us_html_theme_options["use_opensearch"] = False
else:
    # old mess - to be fixed somewhen
    # ? html_use_opensearch = html_theme_options['use_opensearch']
    if not "use_opensearch" in html_theme_options:
        html_theme_options["use_opensearch"] = ""
    elif type(html_theme_options["use_opensearch"]) in [type(""), type(u"")]:
        html_theme_options["use_opensearch"] = html_theme_options[
            "use_opensearch"
        ].rstrip("/")
#
#
#
#
# (6) Settings in MAKEDIR/Overrides.cfg
merge_settings_file(overridesabspath, US)
#
#
#
#
def updateModuleGlobals(GLOBALS, US):
    if "general" in US:
        GLOBALS.update(US["general"])

    if "docstypo3" in US:
        GLOBALS["docstypo3"] = US["docstypo3"]
        # Provide 'description' in the module, if empty but specified in dt3m.
        # The value is used to set up other formats like epub, latex, man, ...
        description = US["docstypo3"].get("meta", {}).get("description", "")
        GLOBALS["description"] = GLOBALS.get("description", "") or description

    # allow comma separated values like: .rst,.md
    if type(GLOBALS["source_suffix"]) in [type(""), type(u"")]:
        GLOBALS["source_suffix"] = [
            v.strip() for v in GLOBALS["source_suffix"].split(",")
        ]

    for k, v in sorted(US.get("exclude_patterns", {}).items()):
        if not v in GLOBALS["exclude_patterns"]:
            GLOBALS["exclude_patterns"].append(v)

    for k, e in US.get("extensions", {}).items():
        if not e in GLOBALS["extensions"]:
            # DISABLED: check for legal_extensions
            if True or e in legal_extensions:
                GLOBALS["extensions"].append(e)

    for k, v in US.get("extlinks", {}).items():
        # untested! but seems to work
        # we expect:
        #     forge = https://forge.typo3.org/issues/%s | forge:
        GLOBALS["extlinks"][k] = (v.split("|")[0].strip(), v.split("|")[1].strip())

    for k, v in US.get("intersphinx_mapping", {}).items():
        GLOBALS["intersphinx_mapping"][k] = (v, None)

    for k, v in US.get("html_theme_options", {}).items():
        GLOBALS["html_theme_options"][k] = v

    for k, v in US.get("graphviz_dot_args_as_dict", {}).items():
        GLOBALS["graphviz_dot_args_as_dict"][k] = v

    # derive default settings for the other builders from the values we
    # already have
    LD = US.get("latex_documents", {})
    GLOBALS["latex_documents"] = [
        (
            firstNotNone(LD.get("source_start_file"), GLOBALS["master_doc"]),
            firstNotNone(LD.get("target_name"), "PROJECT.tex"),
            firstNotNone(LD.get("title"), GLOBALS["project"]),
            firstNotNone(LD.get("author"), GLOBALS["t3author"]),
            firstNotNone(LD.get("documentclass"), "manual"),
        )
    ]
    LE = US.get("latex_elements", {})
    GLOBALS["latex_elements"] = {
        "papersize": firstNotNone(LE.get("papersize"), "a4paper"),
        "pointsize": firstNotNone(LE.get("pointsize"), "10pt"),
        "preamble": firstNotNone(LE.get("preamble"), "%%\\usepackage{typo3}"),
        # for more see: http://sphinx-doc.org/config.html#confval-latex_elements
    }
    MP = US.get("man_pages", {})
    GLOBALS["man_pages"] = [
        (
            firstNotNone(MP.get("source_start_file"), GLOBALS["master_doc"]),
            firstNotNone(MP.get("name"), GLOBALS["project"]),
            firstNotNone(MP.get("description"), GLOBALS["description"]),
            [firstNotNone(MP.get("authors"), GLOBALS["t3author"])],
            firstNotNone(MP.get("manual_section"), 1),
        )
    ]
    TD = US.get("texinfo_documents", {})
    GLOBALS["texinfo_documents"] = [
        (
            firstNotNone(TD.get("source_start_file"), GLOBALS["master_doc"]),
            firstNotNone(TD.get("target_name"), GLOBALS["t3shortname"]),
            firstNotNone(TD.get("title"), GLOBALS["project"]),
            firstNotNone(TD.get("author"), GLOBALS["t3author"]),
            firstNotNone(TD.get("dir_menu_entry"), GLOBALS["project"]),
            firstNotNone(TD.get("description"), GLOBALS["description"]),
            firstNotNone(TD.get("category"), "Miscellaneous"),
        )
    ]
    return


# NOW!
# This is where the magic happens! We update this module's globals()
# with the user settings US. That has the same effect as if the
# settings had been directly written to this conf.py

updateModuleGlobals(G, US)


# define if not existing

if not "epub_author" in G:
    epub_author = t3author
if not "epub_copyright" in G:
    epub_copyright = copyright
if not "epub_publisher" in G:
    epub_publisher = t3author
if not "epub_title" in G:
    epub_title = project

if not "htmlhelp_basename" in G:
    htmlhelp_basename = t3shortname
#
#
#
#
# (7) Settings from ../Makedir/Settings.json
#     This is the "conf_py" subpart of "jobfile.json"
#
# Now: Everything can be overriden. Use at you own risk!
#
if ospe(settingsjsonabspath):
    with codecs.open(settingsjsonabspath, "r", "utf-8") as f1:
        D = json.load(f1)
    # ATTENTION:
    # everything you have in the "general": {k:v} section of Settings.json
    # is treated as if you had written 'k = v' here in conf.py
    globals().update(D.get("general", {}))

    # extensions are now ADDED
    for e in D.get("extensions", []):
        if not e in extensions:
            extensions.append(e)

    extlinks.update(D.get("extlinks", {}))
    html_theme_options.update(D.get("html_theme_options", {}))
    intersphinx_mapping.update(D.get("intersphinx_mapping", {}))
    graphviz_dot_args_as_dict.update(D.get("graphviz_dot_args_as_dict", {}))

    # ATTENTION:
    # settings.json is totally in you hand. No sanity checks are made here.


graphviz_dot_args = ["%s=%s" % (k, v)
                     for k, v in sorted(graphviz_dot_args_as_dict.items())
                     if v != "None"]


# As other modules of Sphinx check the values of conf.py let's do
# a bit of housekeeping und remove helper vars that aren't needed any more.

for k in [
    "config",
    "contents",
    "D",
    "data",
    "e",
    "extensions_to_be_loaded",
    "f1",
    "f1name",
    "item",
    "legal_extensions",
    "o",
    "plantumlfolder",
    "plantumlstylesabspath",
    "read_method",
    "s",
    "section",
    "US",
    "us_general",
    "us_html_theme_options",
    "user_settings",
    "v",
    "WithSection",
]:
    if k in G:
        del G[k]
del k

def json_serializable(obj):
    try:
        json.dumps(obj)
        return True
    except TypeError:
        return False

if 1 and "dump resulting settings as json":
    # This dump is important, as the Docker container refers to it to report
    # back what happened during the build.
    settingsDumpJsonFile = logdirabspath + "/Settings.dump.json"
    with codecs.open(settingsDumpJsonFile, "w", "utf-8") as f2:
        json.dump(
            {k:v for k, v in list(globals().items()) if k not in ["G"] and json_serializable(v)},
            f2, indent=4, sort_keys=True)
    del settingsDumpJsonFile

if 1 and "dump resulting settings as toml":
    settingsDumpTomlFile = logdirabspath + "/Settings.dump.toml"
    with codecs.open(settingsDumpTomlFile, "w", "utf-8") as f2:
        toml.dump(
            {k:v for k, v in list(globals().items()) if k not in ["G"] and json_serializable(v)},
            f2)
    del settingsDumpTomlFile


# From Sphinx "Extensions to theme docs"
def setup(app):
    from sphinx.domains.python import PyField
    from sphinx.util.docfields import Field
    from sphinx.locale import _

    app.add_object_type(
        "confval",
        "confval",
        objname="configuration value",
        indextemplate="pair: %s; configuration value",
        doc_field_types=[],
    )

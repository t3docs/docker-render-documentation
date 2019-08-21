.. include:: ../Includes.txt


===========================
Pygments
===========================

Pygments does syntax highlighting.

http://pygments.org/

In Sphinx the Python `pygments` package is used for syntax highlighting in
**code blocks**.

Pygments is not in charge of highlighting **inline code**. Inline code doesn't
have syntax highlighting. Instead, it may have a specific style dependent on
type (textrole) and our css.

Show help::

   dockrun_t3rd bashcmd "pygmentize -h"


Show package version::

   ➜  ~ dockrun_t3rd bashcmd "pygmentize -V"
   Pygments version 2.4.2, (c) 2006-2019 by Georg Brandl.

   Final exit status: 0 (completed)

   ➜  ~


Show lexers::

   dockrun_t3rd  bashcmd  "pygmentize -L lexers"


TypoScript lexer available? ::

   ➜  ~ dockrun_t3rd  bashcmd  "pygmentize -L lexers | grep -i typoscript"

   * typoscript:
       TypoScript (filenames *.ts, *.txt)

   ➜  ~
**List more:**
The -L option lists lexers, formatters, styles or filters - set
`which` to the thing you want to list (for example "styles"), or omit it to
list everything::

   dockrun_t3rd  bashcmd  "pygmentize -L lexers"
   dockrun_t3rd  bashcmd  "pygmentize -L formatters"
   dockrun_t3rd  bashcmd  "pygmentize -L styles"
   dockrun_t3rd  bashcmd  "pygmentize -L filters"
   dockrun_t3rd  bashcmd  "pygmentize -L"



.. include:: /Includes.rst.txt


===========================
Livereload using Gulp (WIP)
===========================

.. admonition:: WIP - work in progress

   The procdures on this page work, but you may find you have to adapt
   something for your usecase, for example an absolute path.


Run yarn once::

   yarn add gulp
   yarn add gulp-livereload
   yarn add gulp-load-plugins


Update .gitignore::

   #!/bin/bash

   echo '/**/node_modules' >> ../.gitignore
   echo '*GENERATED*' >> ../.gitignore


Create shell script::

   #!/bin/bashdocker-shell-commands.sh

   docker run --rm \
      t3docs/render-documentation:v2.3.0 \
      show-shell-commands \
      > ~/.dockrun/dockrun_t3rd/shell-commands.sh


Run the build repeatedly::

    #!/bin/bash

    source ~/.dockrun/dockrun_t3rd/shell-commands.sh
    cd ..
    mkdir -p tmp-GENERATED-logs
    dockrun_t3rd  makehtml-no-cache \
       > tmp-GENERATED-logs/dockrun_t3rd-makehtml.log.txt


Use this as :file:`gulpfile.js`::

   const { series, watch } = require('gulp');
   const { execSync } = require('child_process');
   const loadPlugins = require('gulp-load-plugins');

   // load all our Gulp plugins
   const $ = loadPlugins();

   function watchSrcTask(cb) {
     const globs = ['../README.rst', '../README.md', '../Documentation/**/*'];
     console.log(`watching ${globs} ...`);
     $.livereload.listen();
     console.log('listening on 35729 for livereload ...');
     watch(globs, {"delay":200}, function(cbb) {
       build(function () {});
       $.livereload.reload();
       cbb();
     });
     cb();
   }
   watchSrcTask.description = 'watch src files, rebuild and livereload on change';


   function build(cb) {
     console.log('building ...');
     // to do: get rid of this specific path specification
     // node: we need the rel->abs path function. Which one is it?
     execSync('/home/marble/Repositories/github.com/t3docs/t3docs-documentation/gulp-livereload-NOT_VERSIONED/4-run-the-build-repeatedly.sh');
     cb();
   }
   build.description = "run build'";


   function usage(cb) {
     msg = 'Usage:\n';
     msg += '  gulp --help\n';
     msg += '  gulp --tasks --depth 0\n';
     msg += '  gulp build\n';
     msg += '  gulp watch &\n';
     console.log(msg);
     cb();
   }
   usage.description = 'show usage';

   exports.build = build;
   exports.help = usage;
   exports.usage = usage;
   exports.watch = watchSrcTask;
   exports.default = series(usage, build, watchSrcTask);


Find some info:

* https://github.com/gulpjs/gulp-cli
* https://nodejs.org/dist/latest-v11.x/docs/api/

Run gulp::

   cd gulp-livereload
   gulp usage
   gulp --help
   gulp build
   gulp watch

Run gulp invisible using 'screen' (`manpage <https://www.mankier.com/1/screen>`__)::

   ((clean up and explain the following))

   screen -dmS t3docs gulp

   # detach from screen with ctrl+A,D
   screen -r

   # kill: 1557825792:0;screen -X -S 9023 quit

   # something useful in this history?
   : 1557825827:0;screen -S diaryblog gulp
   : 1557825930:0;screen -S diaryblog
   : 1557826053:0;screen -S diaryblog -d -m gulp
   : 1557826062:0;screen -ls
   : 1557826153:0;echo screen -S diaryblog -d -m gulp >>1source-me-for-screen-gulp.sh
   : 1557826160:0;cat 1source-me-for-screen-gulp.sh
   : 1557910323:0;screen
   : 1557910332:0;screen -a
   : 1557910424:0;which screen
   : 1557942671:0;screen --version
   : 1557943119:0;screen -r t3docs
   : 1557943191:0;screen --help
   : 1557943196:0;man screen
   : 1558001108:0;screen -dmS drd gulp
   : 1558102159:0;screen -r
   : 1558346526:0;screen -dmS t3docs gulp


Install the livereload extensions for Firefox and Chrome.

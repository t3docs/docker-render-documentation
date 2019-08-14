.. include:: Includes.txt


====================
Livereload with gulp
====================

Run yarn once::

   yarn add gulp
   yarn add gulp-livereload
   yarn add gulp-load-plugins


Update .gitignore::

   #!/bin/bash

   echo '/**/node_modules' >> ../.gitignore
   echo '*GENERATED*' >> ../.gitignore


Create shell script::

   #!/bin/bash

   docker run --rm \
      t3docs/render-documentation:v2.3.0 \
      show-shell-commands \
      > docker-shell-commands.sh


Run the build repeatedly::

    #!/bin/bash

    source docker-shell-commands.sh
    cd ..
    mkdir -p tmp-GENERATED-logs
    dockrun_t3rd makehtml >tmp-GENERATED-logs/dockrun_t3rd-makehtml.log.txt


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

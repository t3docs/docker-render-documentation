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
  execSync('/home/marble/Repositories/github.com/t3docs/docker-render-documentation-draft/gulp-livereload/4-run-the-build-repeatedly.sh');
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

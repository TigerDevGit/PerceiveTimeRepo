var Q     = require('q'),
    slack = require('slack-notify')('https://hooks.slack.com/services/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');

var ROOT = '/home/toggl/toggl_website-TEST/',
    DIST = process.cwd() + '/dist/';

// Currently there is no remoteCwd option so we have to improvise...
// Will prepend cd folder && before any command
function cwdTask(cmd, cwd) {
  return 'cd ' + cwd + ' && ' + cmd;
}

module.exports = function (shipit) {
  shipit.initConfig({
    staging: {
      servers: 'toggl@hubert'
    }
  });

  shipit.task('deploy', function() {
    return shipit.start('build', 'mkDir', 'populatePrev', 'copy', function() {
      slack.send({
        text: this.environment + ' was successfully deployed.',
        username: 'Cap`n Crunch',
        icon_emoji: ':boom:'
      });
    });
  });

  // Create the missing directorys
  // Populate the directorys with prev-assets and current
  // After this step the directory structure should be:
  //
  // ROOT:
  //  - prev-assets
  //  - current
  shipit.blTask('mkDir', function () {
    return Q().then(function () {
      return shipit.remote('mkdir -p ' + ROOT);
    }).then(function () {
      return shipit.remote(cwdTask('mkdir -p prev-assets current', ROOT));
    });
  });

  // Populates the prev-assets folder.
  // We are keeping the last assets in prev-assets folder just in case something goes bad
  shipit.blTask('populatePrev', function () {
    return Q().then(function () {
      return shipit.remote(cwdTask('rm -rf prev-assets', ROOT));
    }).then(function () {
      return shipit.remote(cwdTask('mv current/ prev-assets/', ROOT));
    });
  });

  // Rsyncs local files to current directory
  shipit.blTask('copy', function () {
    return shipit.remoteCopy(DIST, ROOT + 'current/');
  });

  shipit.blTask('build', function() {
    return shipit.local('grunt build');
  });
};

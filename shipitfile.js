var Q     = require('q'),
    slack = require('slack-notify')('https://hooks.slack.com/services/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');

var DIST = process.cwd() + '/dist/';

// Currently there is no remoteCwd option so we have to improvise...
// Will prepend cd folder && before any command
function cwdTask(cmd, cwd) {
  return 'cd ' + cwd + ' && ' + cmd;
}

module.exports = function (shipit) {
  shipit.initConfig({
    staging: {
      servers: 'toggl@hubert',
      root: '/home/toggl/toggl_website/'
    },
    production: {
      servers: [
        'toggl@23.253.62.226:666',
        'toggl@23.253.200.66:666',
        'toggl@23.253.46.149:666',
        'toggl@23.253.62.116:666'
      ],
      root: '/home/toggl/toggl_website'
    }
  });

  shipit.task('deploy', function() {
    return shipit.start('build', 'mkDir', 'populatePrev', 'copy', function(err) {
      if (err) { return; }
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
    var root = this.config.root;
    return Q().then(function () {
      return shipit.remote('mkdir -p ' + root);
    }).then(function () {
      return shipit.remote(cwdTask('mkdir -p prev-assets current', root));
    });
  });

  // Populates the prev-assets folder.
  // We are keeping the last assets in prev-assets folder just in case something goes bad
  shipit.blTask('populatePrev', function () {
    var root = this.config.root;
    return Q().then(function () {
      return shipit.remote(cwdTask('rm -rf prev-assets', root));
    }).then(function () {
      return shipit.remote(cwdTask('mv current/ prev-assets/', root));
    });
  });

  // Rsyncs local files to current directory
  shipit.blTask('copy', function () {
    return shipit.remoteCopy(DIST, this.config.root + 'current/');
  });

  shipit.blTask('build', function() {
    return shipit.local('grunt build');
  });

  shipit.task('bump:minor', function() {
    return shipit.local('npm version minor');
  });

  shipit.task('bumpt:major', function() {
    return shipit.local('npm version major');
  });
};

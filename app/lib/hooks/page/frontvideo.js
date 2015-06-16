var $      = require('jquery'),
  raf      = require('raf'),
  Backbone = require('backbone');

// Because AMD is hard...
// https://github.com/carhartl/jquery-cookie/issues/319
require('jquery.cookie');
require('./froogaloop.js');

var COOKIE_VAL = 'SEEN_VIDEO';

function incrementSeenCount () {
  var current = +$.cookie(COOKIE_VAL) || 0;
  $.cookie(COOKIE_VAL, current + 1);
}

/**
 * Video playback for the homepage video.
 */
module.exports = function(view) {
  var video = view.$('.hero__background iframe').get(0),
      player = $f(video),
      firstTimerHeading = view.$('.hero-timer-heading.dynamic').get(0),
      secondTimerHeading = view.$('.hero-timer-heading.dynamic').get(1),
      timerSeconds = view.$('.hero-timer .seconds').get(0),
      timerMilliseconds = view.$('.hero-timer .milliseconds').get(0),
      breakpoints = [
        {
          time: 0
        },
        {
          time: 5.12,
          firstHeadingText: 'Toggl',
          secondHeadingText: 'great effort'
        },
        {
          time: 14.28,
          secondHeadingText: 'board meetings'
        },
        {
          time: 19.12,
          secondHeadingText: 'textile manufacturing'
        },
        {
          time: 23.4,
          secondHeadingText: 'wobbling matter'
        },
        {
          time: 27.72,
          secondHeadingText: 'patience'
        },
        {
          time: 31.48,
          secondHeadingText: 'time in the doghouse'
        },
        {
          time: 37.92,
          secondHeadingText: 'your holiday'
        },
        {
          time: 41.36,
          secondHeadingText: 'lunch'
        },
        {
          time: 44.84,
          secondHeadingText: 'running late'
        },
        {
          time: 49.48,
          firstHeadingText: '',
          secondHeadingText: 'Toggl anything'
        },
        {
          time: 51.08
        },
        {
          time: 58.32,
          firstHeadingText: '',
          secondHeadingText: ''
        }
      ],
      lastBreakpoint = 0,
      referenceTime,
      referenceDelta = 0,
      running = true, paused = false,
      lastRunningTime = 0;

  if(view.isAprilFools()) {
    breakpoints = [
      {
        time: 0
      },
      {
        time: 9.13,
        firstHeadingText: 'Track',
        secondHeadingText: '"Working"'
      },
      {
        time: 14.64,
        secondHeadingText: 'introspection'
      },
      {
        time: 22.22,
        secondHeadingText: 'deep thoughts'
      },
      {
        time: 28.24,
        secondHeadingText: 'ballistics calculations'
      },
      {
        time: 35.77,
        secondHeadingText: 'remote communication'
      },
      {
        time: 42.12,
        secondHeadingText: 'mining operations'
      },
      {
        time: 50.53,
        secondHeadingText: 'cruisin\''
      },
      {
        time: 55.17,
        secondHeadingText: 'cruisin\''
      },
      {
        time: 59.82,
        secondHeadingText: 'looking for a new job'
      },
      {
        time: 65.93,
        firstHeadingText: '',
        secondHeadingText: ''
      }
    ];
  }

  function throttle(fn, threshhold, scope) {
    threshhold || (threshhold = 250);
    var last,
        deferTimer;
    return function () {
      var context = scope || this;

      var now = +new Date(),
          args = arguments;
      if (last && now < last + threshhold) {
        // hold on to it
        clearTimeout(deferTimer);
        deferTimer = setTimeout(function () {
          last = now;
          fn.apply(context, args);
        }, threshhold);
      } else {
        last = now;
        fn.apply(context, args);
      }
    };
  }

  function resize() {
    var $windowHeight = $(window).height();
    var $videoHeight = view.$(".video").outerHeight();
    if(view.isAprilFools()) {
      var $windowWidth = $(window).width();
      if($windowWidth > 1450) {
        $windowHeight = 805;
      }
      var videoRatio = 281/500;
      var windowRatio = $windowHeight / $windowWidth;
      var videoHeight = $windowWidth * videoRatio;
      if(windowRatio > videoRatio) {
        var videoWidth = ($windowHeight*1.07) / videoRatio;
        view.$('.video .wrapper').css({
          'width': videoWidth + 'px',
          'height': '107%',
          'left': '50%',
          "-webkit-transform" : "translateX(-50%)",
          "transform" : "translateX(-50%)"
        });
      } else {
        view.$('.video .wrapper').css({
          'width': '100%',
          'height': videoHeight + 'px',
          'left': 0,
          "-webkit-transform" : "translateX(0)",
          "transform" : "translateX(0)"
        });
      }
    } else {
      var $scale = $windowHeight / $videoHeight * 1.01;
      if ($videoHeight <= $windowHeight) {
        view.$(".video").css({
          "-webkit-transform" : "scale("+$scale+") translateY(-50%)",
          "transform" : "scale("+$scale+") translateY(-50%)"
        });
      }
    }
  }

  function hideTimer() {
    view.$('.hero-timer').css({'display': 'none', 'opacity': 0});
  }

  function showTimer() {
    view.$('.hero-timer').css({'display': 'block', 'opacity': 1});
  }

  function updateTimer() {
    if (running && !paused) {
      var refTime = referenceTime || new Date().getTime(),
          currentTime = new Date().getTime(),
          timeDifference = Math.floor((currentTime-refTime+referenceDelta)/10),
          minutes,
          seconds,
          milliseconds;

      minutes = Math.floor(timeDifference/(60*100));
      seconds = Math.floor(timeDifference/100)-minutes*60;
      milliseconds = timeDifference - seconds*100 - minutes*60*100;

      if (milliseconds < 10) {
        milliseconds = '0'+milliseconds;
      }

      timerSeconds.textContent = seconds;
      timerMilliseconds.textContent = milliseconds;
    }
    raf(updateTimer);
  }

  function loop(data) {
    if (!running) {
      return;
    }

    lastRunningTime = data.seconds;

    if (data.seconds > 0) {
      view.$('.js-play-pause-controls').show();
    }

    if (!paused) {
      updateTimerHeadings(data.seconds);
    }
  }

  function updateTimerHeadings(currentTime) {
    var firstHeadingText,
        secondHeadingText,
        currentBreakpoint = lastBreakpoint,
        twoFramesBeforeNextBreakpoint = false;

    if (breakpoints.length > currentBreakpoint+1 && currentTime > breakpoints[currentBreakpoint+1].time) {
      // next breakpoint
      currentBreakpoint = currentBreakpoint + 1;

      firstHeadingText = breakpoints[currentBreakpoint].firstHeadingText;
      secondHeadingText = breakpoints[currentBreakpoint].secondHeadingText;
    } else if (breakpoints.length > currentBreakpoint+1 && currentTime > breakpoints[currentBreakpoint+1].time-0.08) {
      // two seconds before next breakpoint
      twoFramesBeforeNextBreakpoint = true;
    } else if (breakpoints.length == currentBreakpoint+1 && currentTime < breakpoints[currentBreakpoint].time) {
      // video restarted
      currentBreakpoint = 0;
    }

    if (currentBreakpoint != lastBreakpoint) {
      if(view.isAprilFools()) {
        switch (currentBreakpoint) {
          case 0:
            hideTimer();
          break;
          case 1:
            showTimer();
            referenceTime = new Date().getTime();
            referenceDelta = 0;
          break;
          case 8:
            referenceDelta = new Date().getTime() - referenceTime;
            referenceTime = undefined;
          break;
          case 10:
            referenceDelta = 0;
            hideTimer();
          break;
          default:
            referenceTime = new Date().getTime();
            referenceDelta = 0;
        }
      } else {
        switch (currentBreakpoint) {
          case 1:
            showTimer();
            referenceTime = new Date().getTime();
          break;
          case 8:
            referenceTime = new Date().getTime()-31080;
          break;
          case 10:
            referenceTime = undefined;
          break;
          case 11:
            referenceTime = new Date().getTime();
          break;
          case 12:
            hideTimer();
            referenceTime = undefined;
          break;
          default:
            referenceTime = new Date().getTime();
        }
      }

      lastBreakpoint = currentBreakpoint;
    }

    if (typeof firstHeadingText != 'undefined') {
      firstTimerHeading.textContent = firstHeadingText;
    }

    if (twoFramesBeforeNextBreakpoint && (currentBreakpoint != 10 || view.isAprilFools())) {
      secondTimerHeading.textContent = '';
      hideTimer();
    } else {
      if (typeof secondHeadingText != 'undefined') {
        secondTimerHeading.textContent = secondHeadingText;
      }
      if (lastBreakpoint && currentBreakpoint != 12) {
        showTimer();
      }
    }
  }

  function handleMuteButtonClick(/*event*/) {
    var mute = this.classList.contains('active');

    this.classList.toggle('active');
    if (mute) {
      player.api('setVolume', 0);
    } else {
      player.api('setVolume', 1);
    }
  }

  function handlePlayButtonClick(event) {
    event.preventDefault();
    player.api('play');
    togglePausePlayButtons(true);
  }

  function handlePauseButtonClick(event) {
    event.preventDefault();
    player.api('pause');
    togglePausePlayButtons(false);
  }

  function togglePausePlayButtons (toggle) {
    view.$('.video-pause-button').toggle(toggle);
    view.$('.video-play-button').toggle(!toggle);
  }

  function detect_autoplay(){
    if('ontouchstart' in document.body){
      running = false;
      document.body.classList.add('video-suspended');

      var heading = document.querySelector('.hero-timer-heading.dynamic'),
          headingText;

      if (heading.dataset) {
        headingText = heading.dataset.defaultText;
      } else {
        headingText = heading.getAttribute('data-default-text');
      }

      heading.textContent = headingText;

      view.$('.hero__background .video').hide();
    } else {
      player.api('setVolume', 0);
      player.api('play');
      player.addEvent('playProgress', throttle(loop, 1000/30));
      raf(updateTimer);
    }
  }

  var MANUAL = 1;
  var AUTOMATIC = 2;
  function setVideoMode(mode) {
    var $automaticVideo = view.$('.js-automatic-video');
    var $manualVideo = view.$('.js-manual-video');

    if(mode === AUTOMATIC) $automaticVideo.show();
    else $automaticVideo.hide();

    if(mode === MANUAL) $manualVideo.show();
    else $manualVideo.hide();

    resize();
  }

  function handleVideoForceStart(event) {
    event.preventDefault();
    detect_autoplay();
    setVideoMode(AUTOMATIC);
  }

  function onDisposed() {
    running = false;
    view.off('remove pre-render', onDisposed);
  }
  view.on('remove pre-render', onDisposed);

  player.addEvent('ready', function() {
    player.addEvent('play', function () {
      incrementSeenCount();
      togglePausePlayButtons(true);
      paused = false;
    });

    player.addEvent('pause', function () {
      togglePausePlayButtons(false);
      paused = true;
    }, true);

    player.addEvent('finish', function () {
      paused = true;
      togglePausePlayButtons(false);
    });

    if ('ontouchstart' in document.body) {
      // Do not show play button for mobile devices
      view.$('.seen-wrapper').hide();
      setVideoMode(MANUAL);

    } else if (Backbone.history.fragment == 'login') {
      incrementSeenCount();
      setVideoMode(MANUAL);
    } else if (+$.cookie(COOKIE_VAL) > 9 && !view.isAprilFools()) {
      // If the user has seen the movie more than 9 times already
      // then lets just not show it
      setVideoMode(MANUAL);
    } else {
      view.$('.js-manual-video').hide();
      setVideoMode(AUTOMATIC);
      detect_autoplay();
      if(!view.isAprilFools()) incrementSeenCount();
    }
  });


  view.$('.video-mute-button').on('click', handleMuteButtonClick);
  view.$('.video-force-start').on('click', handleVideoForceStart);
  view.$('.video-pause-button').on('click', handlePauseButtonClick);
  view.$('.video-play-button').on('click', handlePlayButtonClick);

  $(window).resize(resize);
  resize();
};

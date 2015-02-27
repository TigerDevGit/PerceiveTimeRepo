var $   = require('jquery'),
    raf = require('raf');

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
module.exports = function($page, view) {
  var video = $('.hero__background iframe').get(0),
      player = $f(video),
      firstTimerHeading = $('.hero-timer-heading.dynamic').get(0),
      secondTimerHeading = $('.hero-timer-heading.dynamic').get(1),
      timerSeconds = $('.hero-timer .seconds').get(0),
      timerMilliseconds = $('.hero-timer .milliseconds').get(0),
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
      running = true, paused = false,
      lastRunningTime = 0;

  function throttle(fn, threshhold, scope) {
    threshhold || (threshhold = 250);
    var last,
        deferTimer;
    return function () {
      var context = scope || this;

      var now = +new Date,
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
    var $videoHeight = $(".video").outerHeight();
    var $scale = $windowHeight / $videoHeight * 1.01;

    if ($videoHeight <= $windowHeight) {
      $(".video").css({
        "-webkit-transform" : "scale("+$scale+") translateY(-50%)",
        "transform" : "scale("+$scale+") translateY(-50%)"
      });
    };
  }

  function hideTimer() {
    $('.hero-timer').css('opacity', 0);
  }

  function showTimer() {
    $('.hero-timer').css('opacity', 1);
  }

  function updateTimer() {
    if (running && !paused) {
      var refTime = referenceTime || new Date().getTime(),
          currentTime = new Date().getTime(),
          timeDifference = Math.floor((currentTime-refTime)/10),
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
      $('.js-play-pause-controls').show();
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

      lastBreakpoint = currentBreakpoint;
    }

    if (typeof firstHeadingText != 'undefined') {
      firstTimerHeading.textContent = firstHeadingText;
    }

    if (twoFramesBeforeNextBreakpoint && currentBreakpoint != 10) {
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

  function handleMuteButtonClick(event) {
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
    $('.video-pause-button').toggle(toggle);
    $('.video-play-button').toggle(!toggle);
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

      $('.hero__background .video').hide();
    } else {
      player.api('setVolume', 0);
      player.api('play');
      player.addEvent('playProgress', throttle(loop, 1000/30));
      raf(updateTimer);
    }
  }

  function handleVideoForceStart(event) {
    event.preventDefault();
    detect_autoplay();
    $('.js-manual-video').hide();
    $('.js-automatic-video').show();
  }

  view.on('destroy', function () {
    running = false;
  });


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
      $('.js-manual-video').show();
      $('.js-automatic-video').hide();
      $('.seen-wrapper').hide();
    } else if (+$.cookie(COOKIE_VAL) > 9) {
      // If the user has seen the movie more than 9 times already
      // then lets just not show it
      $('.js-manual-video').show();
      $('.js-automatic-video').hide();
    } else {
      $('.js-manual-video').hide();
      detect_autoplay();
      incrementSeenCount();
    }
  });


  $('.video-mute-button').on('click', handleMuteButtonClick);
  $('.video-force-start').on('click', handleVideoForceStart);
  $('.video-pause-button').on('click', handlePauseButtonClick);
  $('.video-play-button').on('click', handlePlayButtonClick);

  $(window).resize(resize);
  resize();
};

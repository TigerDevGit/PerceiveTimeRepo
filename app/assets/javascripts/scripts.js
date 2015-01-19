/**
* Navigation opening button behaviour
*
* Clicking on .nav-opener toggles 'nav-visible' class on the html element,
* when the html element has this class, main navigation is displayed
* in mobile view.
**/
TogglWeb.navOpenerClick = function(event) {
  var opened = document.querySelector('html').classList.toggle('nav-visible');

  event.stopPropagation();

  if (opened) {
    document.querySelector('.page').addEventListener('click', TogglWeb.navSideClick);

    document.querySelector('.main-nav').style.height = window.innerHeight+'px';
  } else {
    document.querySelector('.page').removeEventListener('click', TogglWeb.navSideClick);
  }
};
TogglWeb.navSideClick = function(event) {
  if (!document.querySelector('.main-nav').contains(event.target)) {
    document.querySelector('html').classList.remove('nav-visible');

    document.querySelector('.page').removeEventListener('click', TogglWeb.navSideClick);
  }
};
var navOpener = document.querySelector('.nav-opener');
if (navOpener) {
  navOpener.addEventListener('click', TogglWeb.navOpenerClick);
}

/**
* Ripple button behaviour
*
* span.js-ripple-button__ripple is appended to each .js-ripple-button element on page load.
* Clicking on .js-ripple-button positions the .js-ripple-button__ripple element under the cursor
* and adds a class that triggers a CSS animation.
*
* When the animation end event is fired, the class is removed from the .js-ripple-button__ripple.
**/
Array.prototype.forEach.call(document.querySelectorAll('.js-ripple-button'), function(element, index, array) {
  var ripple = document.createElement('span');

  ripple.classList.add('js-ripple-button__ripple');

  element.appendChild(ripple);

  element.addEventListener('click', function(event) {
    var ripple = event.target.querySelector('.js-ripple-button__ripple'),
        targetBoundingRectangle = event.target.getBoundingClientRect(),
        rippleX = event.clientX-targetBoundingRectangle.left,
        rippleY = event.clientY-targetBoundingRectangle.top;

    ripple.style.top = Math.round(rippleY)+'px';
    ripple.style.left = Math.round(rippleX)+'px';

    ripple.classList.add('js-ripple-button__ripple--active');
  });
});
Array.prototype.forEach.call(document.querySelectorAll('.js-ripple-button__ripple'), function(element, index, array) {
  element.addEventListener(TogglWeb.animationEndEventName(), function(event) {
    event.target.classList.remove('js-ripple-button__ripple--active');
  });
});

/**
* Stretch content behaviour
*
* Certain elements are given the height of the viewport on load and orientation change.
* Can't use CSS height: 100%, because it doesn't exclude browser chrome in iOS Safari
*
* TODO - only apply styles to appropriate media queries
**/
TogglWeb.handleWindowResize = function(event) {
  if (window.innerWidth < 1450) {
    // frontpage
    if (document.querySelector('.hero--front')) {
      document.querySelector('.hero--front').style.height = window.innerHeight+'px';
    }
    if (window.innerWidth < 500) {
      // features page
      if (document.querySelector('.hero--features')) {
        document.querySelector('.hero--features').style.height = window.innerHeight+'px';
      }
      if (document.querySelector('.fixed-background')) {
        document.querySelector('.fixed-background').style.height = window.innerHeight+'px';
      }
    }
  }
}
window.addEventListener('load', TogglWeb.handleWindowResize);
window.addEventListener('orientationchange', TogglWeb.handleWindowResize);

/**
* Video playback
**/
TogglWeb.frontpageVideo = function() {
  var video = document.querySelector('.hero__background video'),
      firstTimerHeading = document.querySelectorAll('.hero-timer-heading')[0],
      secondTimerHeading = document.querySelectorAll('.hero-timer-heading')[1],
      timerSeconds = document.querySelector('.hero-timer .seconds'),
      timerMilliseconds = document.querySelector('.hero-timer .milliseconds'),
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
      referenceTime;

  function hideTimer() {
    document.querySelector('.hero-timer').style.opacity = 0;
  }

  function showTimer() {
    document.querySelector('.hero-timer').style.opacity = 1;
  }

  function updateTimer() {
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

  function loop() {
    updateTimerHeadings();
    updateTimer();
    window.requestAnimationFrame(loop);
  }

  function updateTimerHeadings() {
    var firstHeadingText,
        secondHeadingText,
        currentBreakpoint = lastBreakpoint,
        twoFramesBeforeNextBreakpoint = false;

    if (breakpoints.length > currentBreakpoint+1 && video.currentTime > breakpoints[currentBreakpoint+1].time) {
      // next breakpoint
      currentBreakpoint = currentBreakpoint + 1;

      firstHeadingText = breakpoints[currentBreakpoint].firstHeadingText;
      secondHeadingText = breakpoints[currentBreakpoint].secondHeadingText;
    } else if (breakpoints.length > currentBreakpoint+1 && video.currentTime > breakpoints[currentBreakpoint+1].time-0.08) {
      // two seconds before next breakpoint
      twoFramesBeforeNextBreakpoint = true;
    } else if (breakpoints.length == currentBreakpoint+1 && video.currentTime < breakpoints[currentBreakpoint].time) {
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
    video.muted = mute;
  }

  function detect_autoplay(){
    if('ontouchstart' in document.body){
      document.body.classList.add('video-suspended');

      var heading = document.querySelector('.hero-timer-heading'),
          headingText;

      if (heading.dataset) {
        headingText = heading.dataset['defaultText'];
      } else {
        headingText = heading.getAttribute('data-default-text');
      }

      heading.textContent = headingText;
    } else {
      window.requestAnimationFrame(loop);
    }
  }


  return {
    init: function() {
      document.querySelector('.video-mute-button').addEventListener('click', handleMuteButtonClick)

      detect_autoplay();
    }
  }
}();

/**
* Timer behaviour
*
* Tracks time on current page, displays it in .timer__text, handles click on .timer__button.
**/
TogglWeb.Timer = function() {
  var secondsTracked = 0,
      interval,
      timerTimeElement;

  function startTimer() {
    interval = setInterval(timerLoop, 1000);
  };

  function pauseTimer() {
    clearInterval(interval);
  };

  function timerLoop() {
    var components = [],
        hours,
        minutes,
        seconds;

    secondsTracked ++;

    if (secondsTracked >= 3600) {
      // hh:mm:ss
      hours = Math.floor(secondsTracked / 3600);

      if (hours < 10) {
        hours = '0' + hours;
      }

      components.push(hours);
    }

    if (secondsTracked >= 60) {
      // mm:ss min
      minutes = Math.floor((secondsTracked - (hours?hours * 3600:0)) / 60);

      if (minutes < 10) {
        minutes = '0' + minutes;
      }

      components.push(minutes);
    }
    // s sec
    seconds = secondsTracked - (hours?hours * 3600:0) - (typeof minutes != 'undefined'?minutes * 60:0);

    if (typeof minutes != 'undefined' && seconds < 10) {
      seconds = '0' + seconds;
    }

    components.push(seconds);

    timerTimeElement.textContent = components.join(':') + (typeof minutes != 'undefined'?hours?'':' min':' sec');
  };

  function attachListeners() {
    document.querySelector('.timer__button').addEventListener('click', handleTimerButtonClick);
  };

  function handleTimerButtonClick(event) {
    var resumed = event.target.classList.toggle('timer__button--stop');

    if (resumed) {
      startTimer();

      event.target.innerHTML = event.target.innerHTML.replace('Start', 'Stop');
    } else {
      pauseTimer();

      event.target.innerHTML = event.target.innerHTML.replace('Stop', 'Start');
    }
  };


  return {
    init: function() {
      timerTimeElement = document.querySelector('.timer__time');

      startTimer();
      attachListeners();
    }
  };
}();

/**
* Features page animated pie chart
**/
TogglWeb.PieChart = function() {
  var canvas,
      ctx,
      segments = [
        {
          size: 0.3,
          color: '#cfcfcf'
        },
        {
          size: 0.1,
          color: '#d9d9d9'
        },
        {
          size: 0.2,
          color: '#e7e7e7'
        },
        {
          size: 0.4,
          color: '#f30c16'
        }
      ],
      animationRunning = false,
      animationStartTime,
      currentTime,
      animationCompletedPercent,
      animationCompleted = false,
      settings = {
        strokeWidth: 86,
        radius: 115,
        center: {},
        animationLength: 1000,
        counterclockwise: true
      };

  function scaleCanvas() {
    if (window.devicePixelRatio) {
      var canvasWidth = canvas.width,
          canvasHeight = canvas.height;

      canvas.width = canvasWidth * window.devicePixelRatio;
      canvas.height = canvasHeight * window.devicePixelRatio;

      ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
    }
  };

  function checkCanvasVisibility() {
    var canvasBoundingRect = canvas.getBoundingClientRect();

    if (!animationRunning) {
      if (canvasBoundingRect.top < window.innerHeight * 0.75 && canvasBoundingRect.bottom > window.innerHeight * 0.25) {
        startAnimation();
      }
    } else {
      if (canvasBoundingRect.top > window.innerHeight || canvasBoundingRect.bottom < 0) {
        animationRunning = false;

        canvas.parentNode.classList.remove('pie-chart--animation-complete');
        clear();
      }
    }

    requestAnimationFrame(checkCanvasVisibility);
  };

  function startAnimation() {
    animationStartTime = new Date().getTime();

    animationRunning = true;
    animationCompleted = false;
    animationCompletedPercent = 0;

    loop();
  };

  function loop() {
    currentTime = new Date().getTime() - animationStartTime;
    animationCompletedPercent = animationCompletedPercent = currentTime / settings.animationLength;

    if (animationCompletedPercent >= 1) {
      animationCompletedPercent = 1;
      animationCompleted = true;
    }

    clear();
    draw();

    if (animationCompleted) {
      canvas.parentNode.classList.add('pie-chart--animation-complete');
    } else {
      enqueue();
    }
  };

  function clear() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  };

  function draw() {
    var startAngle,
        endAngle;

    segments.forEach(function(segment, index, array) {
      var arcLength = 2 * Math.PI * segment.size * animationCompletedPercent;

      if (index == 0) {
        startAngle = 2 * Math.PI * -0.25;
      } else {
        startAngle = endAngle;
      }

      if (settings.counterclockwise) {
        endAngle = startAngle - arcLength;
      } else {
        endAngle = startAngle + arcLength;
      }

      ctx.beginPath();

      ctx.strokeStyle = segment.color;

      ctx.arc(settings.center.x, settings.center.y, settings.radius, startAngle, endAngle, settings.counterclockwise);

      ctx.stroke();
    });
  };

  function enqueue() {
    requestAnimationFrame(loop);
  };

  function handleCanvasClick(event) {
    canvas.parentNode.classList.remove('pie-chart--animation-complete');

    startAnimation();
  };

  return {
    init: function() {
      canvas = document.getElementById('js-pie-chart-canvas');
      ctx = canvas.getContext('2d');

      settings.center.x = canvas.width/2;
      settings.center.y = canvas.height/2;

      scaleCanvas();

      ctx.lineWidth = settings.strokeWidth;

      requestAnimationFrame(checkCanvasVisibility);

      canvas.addEventListener('click', handleCanvasClick);
    }
  }
}();

/**
* Adds a 'scroll-revealed' class to .js-scroll-reveal elements when they are scrolled
* into viewport.
*
* Images with class js-scroll-reveal are automatically faded into view, for more complex
* behaviour, define your own transitions in CSS (like in style.css#PLATFORMS-LIST)
**/
TogglWeb.ScrollReveal = function() {
  var elements = [];

  function checkScroll() {
    var index = 0;

    elements.forEach(function(element, index, array) {
      var elementBoundingRect = element.getBoundingClientRect();

      if (elementBoundingRect.top < window.innerHeight * 0.75 && elementBoundingRect.bottom > window.innerHeight * 0.25) {
        element.classList.add('scroll-revealed');
      } else {
        element.classList.remove('scroll-revealed');
      }
    });
    
    requestAnimationFrame(checkScroll);
  };

  return {
    init: function() {
      elementsNodeList = document.querySelectorAll('.js-scroll-reveal');
      for (var index = 0, element; element = elementsNodeList[index]; ++index) elements.push(element);

      requestAnimationFrame(checkScroll);
    }
  }
}();

/**
* Reveals the #login-overlay modal overlay when the user clicks on .js-login-button.
* Hides the overlay when the user clicks directly on the overlay.
**/
TogglWeb.openModal = function() {
  document.body.classList.add('with-modal-overlay');
  document.querySelector('#login-overlay').classList.add('modal-overlay--visible');

  TogglWeb.addModalClosingEvents();
};
TogglWeb.closeModal = function() {
  document.body.classList.remove('with-modal-overlay');
  document.querySelector('#login-overlay').classList.remove('modal-overlay--visible');

  TogglWeb.removeModalClosingEvents();
};
TogglWeb.handleLoginLinkClick = function(event) {
  event.preventDefault();

  TogglWeb.openModal();
};
TogglWeb.handleOverlayClick = function(event) {
  if (event.target.classList.contains('modal-overlay')) {
    TogglWeb.closeModal();
  }
};
TogglWeb.handleOverlayKeyPress = function(event) {
  if (event.keyCode == 27) {
    TogglWeb.closeModal();
  }
};
TogglWeb.handleOverlayCloseClick = function(event) {
  TogglWeb.closeModal();
};
TogglWeb.addModalClosingEvents = function() {
  document.querySelector('#login-overlay').addEventListener('click', TogglWeb.handleOverlayClick);
  document.querySelector('.modal-overlay__close').addEventListener('click', TogglWeb.handleOverlayCloseClick);
  document.addEventListener('keypress', TogglWeb.handleOverlayKeyPress);
};
TogglWeb.removeModalClosingEvents = function() {
  document.querySelector('#login-overlay').removeEventListener('click', TogglWeb.handleOverlayClick);
  document.querySelector('.modal-overlay__close').removeEventListener('click', TogglWeb.handleOverlayCloseClick);
  document.removeEventListener('keypress', TogglWeb.handleOverlayKeyPress);
};
var loginButton = document.querySelector('.js-login-button');
if (loginButton) {
  loginButton.addEventListener('click', TogglWeb.handleLoginLinkClick);
  document.querySelector('.modal-overlay').addEventListener('click', TogglWeb.handleOverlayClick);
}

/**
* Removes the "no-transitions" class from body on page load.
* This class is required to prevent webkit browsers (e.g. Safari) from firing transitions
* on page load.
**/
window.addEventListener('load', function() {
  document.body.classList.remove('no-transitions');
});

/**
* Toggls team member boxes in team view
**/
TogglWeb.handleTeamMemberClick = function(event) {
  var target = event.target;

  while (!target.classList.contains('team__member')) {
    target = target.parentNode;
  }

  if (target.classList.contains('team__member--expanded')) {
    target.classList.remove('team__member--expanded');
  } else {
    var expandedBlock = document.querySelector('.team__member--expanded');

    if (expandedBlock) {
      expandedBlock.classList.remove('team__member--expanded');
    }
    
    target.classList.add('team__member--expanded');
  }
};
Array.prototype.forEach.call(document.querySelectorAll('.team__member'), function(element, index, array) {
  element.addEventListener('click', TogglWeb.handleTeamMemberClick);
});
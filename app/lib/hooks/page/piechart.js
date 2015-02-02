var $   = require('jquery'),
    raf = require('animation-frame');

module.exports = function () {
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
  }

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

    raf(checkCanvasVisibility);
  }

  function startAnimation() {
    animationStartTime = new Date().getTime();

    animationRunning = true;
    animationCompleted = false;
    animationCompletedPercent = 0;

    loop();
  }

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
  }

  function clear() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  }

  function draw() {
    var startAngle,
        endAngle;

    segments.forEach(function(segment, index, array) {
      var arcLength = 2 * Math.PI * segment.size * animationCompletedPercent;

      if (index === 0) {
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
  }

  function enqueue() {
    raf(loop);
  }

  function handleCanvasClick(event) {
    canvas.parentNode.classList.remove('pie-chart--animation-complete');

    startAnimation();
  }

  canvas = document.getElementById('js-pie-chart-canvas');
  ctx = canvas.getContext('2d');

  settings.center.x = canvas.width/2;
  settings.center.y = canvas.height/2;

  scaleCanvas();

  ctx.lineWidth = settings.strokeWidth;

  raf(checkCanvasVisibility);

  canvas.addEventListener('click', handleCanvasClick);
};

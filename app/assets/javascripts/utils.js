/**
*
**/
var TogglWeb = {};

TogglWeb.animationEndEventName = function() {
  var fakeElement = document.createElement('fake');

  var animationEventNames = {
    'animation': 'animationend',
    'OAnimation': 'OAnimationEnd',
    'MozAnimation': 'animationend',
    'WebkitAnimation': 'webkitAnimationEnd'
  };

  for (var name in animationEventNames) {
    if (fakeElement.style[name] != undefined) {
      return animationEventNames[name];
    }
  }
}
var $ = require('jquery');

module.exports = function ($page, view) {
  var elements = $('.js-scroll-reveal').toArray();

  function checkScroll() {
    var index = 0;

    for (var i = 0, l = elements.length; i < l; i++) {
      var element = elements[i];
      var offset = $(element).offset();
      var height = $(element).height();

      if (offset.top < window.scrollY + window.innerHeight * 0.75 &&
          offset.top + height  > window.scrollY + window.innerHeight * 0.25) {
        element.classList.add('scroll-revealed');
      } else {
        element.classList.remove('scroll-revealed');
      }
    }

    requestAnimationFrame(checkScroll);
  }

  $(document).on('scroll', checkScroll);
  // When we navigate away from the page, remove the scroll handler.
  view.on('destroy', function () {
    $(document).off('scroll', checkScroll);
  });
};

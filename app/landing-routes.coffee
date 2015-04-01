# Routes for landing pages.
#
# How to add custom meta tags:
#
#  add them under the route with key `meta`.
#  example:
#
#     ```
#      'best-free-time-tracking-app-for-iphone':
#        title: 'Best free time tracking app for iphone'
#        template: 'iphone'
#        meta: [{
#          name: 'TEST'
#          content: 'TEST-CONTENT'
#        }]
#     ```
#
#  will add a following meta tag for the page:
#  `<meta name="TEST" content="TEST-CONTENT">`
#
#  The keys for the meta tags can be custom, so if you wanted to create a meta
#  tag for some OG image it would look like this:
# ```
#   meta: [{
#     property: 'og-image'
#     content: 'https://media0.giphy.com/media/jA8TT03Sj2pXO/200_s.gif'
#   }]
# ```
#

module.exports =
  'best-free-time-tracking-app-for-iphone':
    title: 'Best free time tracking app for iphone'
    template: 'iphone'

  'best-free-time-tracking-app-for-android':
    title: 'Best free time tracking app for android'
    template: 'android'

  'trello-time-tracking':
    title: 'Time tracking integration with Trello'
    template: 'trello'

  'work-management-software':
    title: 'Toggl - Free Work Management Software'
    template: 'work-management'

  'project-time-management':
    title: 'Toggl - Free Project Time Management Software'
    template: 'project-management'

  'employee-time-management':
    title: 'Toggl - Online Employee Time Management Software'
    template: 'employee-management'

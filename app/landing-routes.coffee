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
#  The keys for the meta tags can be custom, so if you wanted to create a meta tag for some OG image it would look like this:
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
    meta: [{
      name: 'description'
      content: 'Analyize your time usage by tracking daily activites on your iPhone. All the data is synced to the cloud and can be exported as online timesheet.'
      },{
      property: 'og-image'
      content: 'https://toggl.com/photos/toggl-iphone-timesheet.jpg'
    }]

  'best-free-time-tracking-app-for-android':
    title: 'Best free time tracking app for android'
    template: 'android'
    meta: [{
      name: 'description'
      content: 'Analyize your time usage by tracking daily activites on your Android phone. All the data is synced to the cloud and can be exported as online timesheet.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'trello-time-tracking':
    title: 'Time tracking integration with Trello'
    template: 'trello'
    meta: [{
      name: 'description'
      content: 'Track time spent on Trello tasks and export timesheets in Toggl. Managing work time with this simple Chrome extension is really quick and easy.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'work-management-software':
    title: 'Toggl - Free Work Management Software'
    template: 'work-management'
    meta: [{
      name: 'description'
      content: 'Set up projects and track them in real time. Then analyze your work time profitability and productivity with the help of different Toggl reports, graphs and dashboards.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'project-time-management':
    title: 'Toggl - Free Project Time Management Software'
    template: 'project-management'
    meta: [{
      name: 'description'
      content: 'Analyize project time usage by tracking daily activites with the whole team. All the data is synced to the cloud and can be exported as online timesheet or viewed on different dashboards.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'employee-time-management':
    title: 'Toggl - Online Employee Time Management Software'
    template: 'employee-management'
    meta: [{
      name: 'description'
      content: 'Analyize the time usage of your employees. Very simple setup and easy real time tracking. All the data is synced to the cloud and can be exported as online timesheets.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'google-calendar-timer-integration':
    title: 'Best time tracking integration with Google Calendar'
    template: 'google_calendar'
    meta: [{
      name: 'description'
      content: 'Directly track time spent on calendar events and export timesheets from Toggl. Managing work time with Google Calendar and Toggl is really quick and easy with this simple Chrome extension.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

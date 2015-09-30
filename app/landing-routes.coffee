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
    template: 'google-calendar'
    meta: [{
      name: 'description'
      content: 'Directly track time spent on calendar events and export timesheets from Toggl. Managing work time with Google Calendar and Toggl is really quick and easy with this simple Chrome extension.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'online-timesheet-software':
    title: 'Toggl - Online Timesheet Software'
    template: 'online-timesheet'
    meta: [{
      name: 'description'
      content: 'Analyize the time usage of your employees. Use timer or add time logs manually. All the data is synced to the cloud and generated into useful time reports and graphs.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'work-time-measuring-web-app':
    title: 'Toggl - Free Work Time Measuring Web App'
    template: 'work-measuring'
    meta: [{
      name: 'description'
      content: 'Analyize work time usage by tracking daily activites. All the data is synced to the cloud and can be exported as online timesheet or viewed on different dashboards.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'customer-profitability-analysis-software':
    title: 'Toggl - Customer Profitability Analysis Software'
    template: 'customer-profitability'
    meta: [{
      name: 'description'
      content: 'Analyize your project time usage by tracking daily tasks and see how much time each customer takes out of your day. All the data is synced to the cloud and can be exported as online timesheet or viewed on different dashboards.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'best-time-keeping-software-lawyers':
    title: 'Toggl - Best Time Keeping Software For Lawyers'
    template: 'lawyers'
    meta: [{
      name: 'description'
      content: 'Track time spent on client tasks, calls, meetings and e-mails. Automatic rounding option, different billable rates and powerful reports make it the best time tracking software for lawyers and attorneys.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'best-time-reporting-software-freelancers':
    title: 'Toggl - Best Time Reporting Software For Freelancers'
    template: 'freelancers'
    meta: [{
      name: 'description'
      content: 'Track time spent on client tasks, calls, meetings and e-mails. Different billable rates and reports sharing make it the best time tracking software for freelancers.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'corporate-timesheet-alternative-application':
    title: 'Toggl - The Best Alternative To Corporate Timesheets'
    template: 'timesheet-alternative'
    meta: [{
      name: 'description'
      content: 'Track and analyize your work hours without the time-wasting spreasheet filling. Use timer or add time logs manually. All the data is synced to the cloud and generated into useful time reports and pretty graphs.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'work-hours-tracking':
    title: 'Toggl - Free Web App For Tracking Work Hours'
    template: 'hours-tracking'
    meta: [{
      name: 'description'
      content: 'Analyize work time usage by tracking daily activites. All the data is synced to the cloud and can be exported as online timesheet or viewed on different dashboards.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'task-duration-tracking-tool':
    title: 'Toggl - Free Online Task Tracking Tool'
    template: 'task-tracking'
    meta: [{
      name: 'description'
      content: 'Analyize task time usage by tracking daily activites on the web and with Android or iPhone app. All the data is synced to the cloud and can be exported as online timesheet or viewed on different dashboards.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'company-productivity-analysis-web-app':
    title: 'Toggl - Company Productivity Analysis Through Time Tracking'
    template: 'company-productivity'
    meta: [{
      name: 'description'
      content: 'Analyize the time usage of your employees. Very simple setup and easy real time tracking. All the data is synced to the cloud and can be exported as online timesheets.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'best-time-tracking-software-windows':
    title: 'Toggl - Free Time Tracking Software For Windows'
    template: 'windows'
    meta: [{
      name: 'description'
      content: 'Analyize work time usage by tracking daily activites. All the data is synced to the cloud and can be exported as online timesheet or viewed on different dashboards in the web version.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'daily-battles':
    title: 'Toggl - We battle daily'
    template: 'daily-battles'
    meta: [{
      name: 'description'
      content: 'Victory shall be ours'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

  'best-productivity-tools-2016':
    title: 'Must-have Tools to Increase Productivity in 2016'
    template: 'best-productivity-tools-2016'
    meta: [{
      name: 'description'
      content: 'Comprehensive overview of the best free time management tools to use in 2016. Most of these productivity boosting tools are cloud based.'
      },{
      property: 'og-image'
      content: 'https://www.toggl.com/images/share-img/fb-share-img.jpg'
    }]

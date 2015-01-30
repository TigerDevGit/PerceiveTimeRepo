includeFolder = require 'include-folder'
_ = require 'underscore'

templateDirs = {
  component: includeFolder(__dirname + '/component')
  page: includeFolder(__dirname + '/page')
  partials: includeFolder(__dirname + '/partials')
}

dasherize = (str) ->
  maxI = str.length - 1
  _.reduce(str, ((m, c, i) ->
    lc = c.toLowerCase()
    m += if lc != c and i != maxI then "-#{lc}" else lc
    m
  ), "")

exports = module.exports = (Handlebars) ->
  ret = {}
  for dir, templates of templateDirs
    for name, template of templates
      c = ret[dir + '/' + name] = Handlebars.compile template
      if dir == 'partials'
        Handlebars.registerPartial(dasherize(name), c)
  ret

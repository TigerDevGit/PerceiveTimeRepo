# Parses a QueryString as an Object
parseQuery = (qs) ->
  qs = qs.slice(1) if qs[0] == '?'
  ret = {}
  for pair in qs.split '&'
    [key, value] = pair.split '='
    ret[decodeURIComponent(key)] = decodeURIComponent(value)
  ret

exports = module.exports = parseQuery

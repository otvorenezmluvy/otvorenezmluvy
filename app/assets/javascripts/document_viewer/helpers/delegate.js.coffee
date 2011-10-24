window.delegate = (methods, options) ->
  for method in methods
    do(method) ->
      if method instanceof Object
        for own property of method
          source_method = property
          break
        target_method = method[source_method]
      else
        source_method =  target_method = method

      options.from[source_method] = ->
        target = options.to.apply(options.from)
        target[target_method].apply(target, arguments)



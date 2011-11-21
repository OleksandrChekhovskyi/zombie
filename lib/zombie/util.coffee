
# Triggers an error event on the specified element.  Accepts:
# element - Element/document associated wit this error
# skip    - Filename of the caller (__filename), we use this to trim the stack trace
# scope   - Execution scope, e.g. "XHR", "Timeout"
# error   - Actual Error object
exports.raise = (element, from, scope, error)->
  document = element.ownerDocument || element
  window = document.parentWindow
  message = if scope then "#{scope}: #{error.message}" else error.message
  # Deconstruct the stack trace and strip the Zombie part of it
  # (anything leading to this file).  Add the document location at
  # the end.
  partial = []
  for line in error.stack.split("\n")
    break if ~line.indexOf(from)
    partial.push line
  partial.push "    in #{document.location.href}"
  error.stack = partial.join("\n")

  event = document.createEvent("Event")
  event.initEvent "error", false, false
  event.message = error.message
  event.error = error
  window.dispatchEvent event

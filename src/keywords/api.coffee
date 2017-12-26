_ = require 'lodash'
{timeout, printable} = require '../libs/utils'

cond  = protractor.ExpectedConditions
DEFAULT_TIMEOUT = -> testx.params.actionTimeout || 5000

get = (key) ->
  testx.element(key).wait(DEFAULT_TIMEOUT()).then -> testx.element(key).get()
getAll = (key) ->
  els = testx.elements key
  els.count().then (e) ->
    console.log key, e
    if e is 0
      Promise.resolve []
    else
      els.wait(DEFAULT_TIMEOUT()).then -> els
set = (key, value) ->
  wait {objects: [key]}, cond.elementToBeClickable
  testx.element(key).set value
wait = (args, condition = cond.visibilityOf) ->
  for obj in args.objects
    tmt = timeout args.timeout, DEFAULT_TIMEOUT()
    (testx.element obj).wait tmt, condition

module.exports =
  get: get
  getAll: getAll
  set: set
  wait: wait
  convertSimpleArgs: (args, defaultArg) ->
    if Array.isArray args or typeof args isnt 'object'
      arg = args
      args = {}
      args[defaultArg] = arg
    args
  assertFailedMsg: (ctx) ->
    location = printable _.pick ctx._meta, 'file', 'sheet', 'Row'
    "Assertion failure at #{location}"

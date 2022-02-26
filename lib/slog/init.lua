local path = ...

return {
  frame = require(path .. '.frame'),
  icon  = require(path .. '.icon'),
  pixel = require(path .. '.pixel'),
  text  = require(path .. '.text')
}


local CHECKER = require "checker"
local LOADER = require "loader"

local simulator_impl_path, scenario_path = ...

if not simulator_impl_path then
  return print "Please provide the simulator implementation directory path"
elseif not scenario_path then
  return print "Please provide the scenarios directory path"
end

LOADER.addPath(simulator_impl_path)

return CHECKER.check(scenario_path)


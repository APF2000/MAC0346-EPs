
local LOADER = require "loader"

local CHECKER = {}

CHECKER.fields = {
  'hp',
}

function CHECKER.check(scenario_path)
  local simulator = require "simulator"
  local scenario = LOADER.load(scenario_path)
  local result = simulator.run(scenario.input)

  local mistakes = CHECKER.compare(result, scenario.output.units)

  for _, mistake in ipairs(mistakes) do
    local fmt = "$name's $field is wrong: found $found but expected $expected"
    print((fmt:gsub("$(%w+)", mistake)))
  end
end

function CHECKER.compare(received_state, expected_state)
  local mistakes = {}
  for _, field in ipairs(CHECKER.fields) do
    for name, unit in pairs(received_state) do
      local found, expected = unit[field], expected_state[name][field]
      if found ~= expected then
        mistakes[#mistakes+1] = {
          name = name, field = field, found = found, expected = expected
        }
      end
    end
  end
  return mistakes
end

return CHECKER


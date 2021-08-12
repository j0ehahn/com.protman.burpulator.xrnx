local dialog = nil
local vb = nil

class "RenoiseScriptingTool"(renoise.Document.DocumentNode)
function RenoiseScriptingTool:__init()
  renoise.Document.DocumentNode.__init(self)
  self:add_property("Name", "Untitled Tool")
  self:add_property("Version", "1.0")
end

local manifest = RenoiseScriptingTool()
local ok, err = manifest:load_from("manifest.xml")
local tool_name = manifest:property("Name").value
local tool_version = manifest:property("Version").value

local function disable_sample_interpolation()
  local count = 0
  for instrument_index, instrument in ipairs(renoise.song().instruments) do
    for sample_index, sample in ipairs(instrument.samples) do
      sample.interpolation_mode = renoise.Sample.INTERPOLATE_NONE
      sample.oversample_enabled = false
      count = count + 1
    end
  end
  renoise.app():show_status(string.format("Changed %d sample(s)", count))
end

local function enable_sample_interpolation()
  local count = 0
  for instrument_index, instrument in ipairs(renoise.song().instruments) do
    for sample_index, sample in ipairs(instrument.samples) do
      sample.interpolation_mode = renoise.Sample.INTERPOLATE_SINC
      sample.oversample_enabled = true
      count = count + 1
    end
  end
  renoise.app():show_status(string.format("Changed %d sample(s)", count))
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:burpulator ON",
  invoke = function()
    disable_sample_interpolation()
  end
}

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:burpulator OFF",
  invoke = function()
    enable_sample_interpolation()
  end
}

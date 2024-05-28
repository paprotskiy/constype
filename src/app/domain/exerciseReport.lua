local overlayableChar = require("app.domain.lexic.char")
local charedTopic = require("app.domain.lexic.topic")
local charset = require("app.domain.lexic.charset")
local char = require("app.domain.lexic.char")

return {
	BuildReport = function(topic)
		return {
			Good = 23,
			Errors = 4,
			TimeTotal = 45,
			TimeLostOnErrors = 14,
			ErrorsRatio = 0.2,
			WastedTimeRatio = 0.3,
		}
	end,
}

local overlayableChar = require("app.domain.lexic.char")
local charedTopic = require("app.domain.lexic.topic")
local charset = require("app.domain.lexic.charset")
local char = require("app.domain.lexic.char")

return {
	BuildReport = function(topic)
		return {
			Good = 23,
			Errors = 4,
			TimeTotal = "45 seconds",
			TimeLostOnErrors = "14 seconds",
		}
	end,
}

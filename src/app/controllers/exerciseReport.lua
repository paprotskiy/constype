local overlayableChar = require("app.domain.lexic.char")
local view = require("app.ui.view.exerciseReport")
local model = require("app.domain.exerciseReport")

local exerciseController = function(baseControllerInvoke, topic)
	local report = model.BuildReport(topic)

	return {
		Load = function()
			view:Load(report)
		end,

		Close = function()
			view:Close()
		end,

		HandleSignal = function(self, atomicSignal)
			local action = self[atomicSignal]

			if action == nil then
				return self.Default
			end
			return action
		end,

		Default = function(_, _) end,

		--  todo make backspace const
		[string.char(127)] = function(_, _)
			baseControllerInvoke:Start()
		end,

		-- todo make esc const
		[string.char(27)] = function(_, _)
			baseControllerInvoke:Start()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, _)
			baseControllerInvoke:Start()
		end,
	}
end

return {
	New = exerciseController,
}

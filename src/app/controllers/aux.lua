local viewAux1 = require("app.ui.view.aux")

local auxController = function(baseControllerInvoke)
	return {
		Load = function()
			viewAux1:Load()
		end,

		Close = function()
			viewAux1:Close()
		end,

		HandleSignal = function(self, atomicSignal)
			local action = self[atomicSignal]

			if action == nil then
				return self.Default
			end
			return action
		end,

		-- todo make esc const
		[string.char(27)] = function(self) end,

		["l"] = function(_)
			baseControllerInvoke:Aux2()
		end,

		["h"] = function(_)
			baseControllerInvoke:Start()
		end,

		Default = function(_, signalChar) end,
	}
end

return {
	New = auxController,
}

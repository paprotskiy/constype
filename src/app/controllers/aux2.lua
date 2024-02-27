local viewAux2 = require("app.ui.view.aux2")

local auxController = function(baseControllerInvoke)
	return {
		Load = function()
			viewAux2:Load()
		end,

		Close = function()
			viewAux2:Close()
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
			viewAux2.Print("no way! ")
		end,

		["h"] = function(_)
			baseControllerInvoke:Aux()
		end,
		--  todo make backspace const
		[string.char(127)] = function(_) end,
		--  todo make enter const
		[string.char(10)] = function(_) end,

		Default = function(_, signalChar)
			-- viewAux2.Print(signalChar)
		end,
	}
end

return {
	New = auxController,
}

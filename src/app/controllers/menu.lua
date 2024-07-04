local view = require("app.ui.view.menu")
local model = require("app.domain.menu")

local MenuController = function(baseControllerInvoke, cfg)
	local menuList = model:New()

	return {
		Load = function()
			local list = menuList:List()

			-- todo DTO layer required
			local val = {}
			for _, v in ipairs(list) do
				table.insert(val, {
					Value = v.Title,
				})
			end

			view:Load(cfg, val)
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

		Default = function(_, signalChar) end,

		["j"] = function(_, _)
			view:PickNext()
		end,

		["k"] = function(_, _)
			view:PickPrev()
		end,

		--  todo make backspace const
		[string.char(127)] = function(_, _)
			baseControllerInvoke:Bye()
		end,

		-- todo make esc const
		[string.char(27)] = function(_, _)
			baseControllerInvoke:Bye()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, _)
			local curr = view:GetCurrent()

            if curr.Value == "pick-plan" then
                baseControllerInvoke:PickPlan()
            elseif curr.Value == "import-as-plan" then
                baseControllerInvoke:ImportAsPlan()
            end
		end,
	}
end

return {
	New = MenuController,
}

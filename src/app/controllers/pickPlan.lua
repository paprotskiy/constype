local overlayableChar = require("app.domain.lexic.char")
local view = require("app.ui.view.pickPlan")
local model = require("app.domain.pickPlan")
local pp = require("utils.print.pretty")

local pickPlanController = function(baseControllerInvoke, cfg, storage)
	local planList = model:New(storage)

	return {
		Load = function()
			local plans = planList:List()

			-- todo DTO layer required
			local keyval = {}
			for _, v in ipairs(plans) do
				table.insert(keyval, {
					Key = v.Id,
					Value = v.Title,
				})
			end

			view:Load(cfg, keyval)
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
			baseControllerInvoke:PickTopic(curr.Key)
		end,
	}
end

return {
	New = pickPlanController,
}

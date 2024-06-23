local overlayableChar = require("app.domain.lexic.char")
local view = require("app.ui.view.pickTopic")
local model = require("app.domain.pickTopic")
local pp = require("utils.print.pretty")

local function pickTopicController(baseControllerInvoke, storage, planId)
	return {
		Load = function()
			view:Load()
			local topicData = model:FirstUnfinished(storage, planId)
			if topicData == nil then
				baseControllerInvoke:PlanReport(planId)
				return
			end

			baseControllerInvoke:Exercise(planId, topicData)
		end,

		Close = function()
			view:Close()
		end,
	}
end

return {
	New = pickTopicController,
}

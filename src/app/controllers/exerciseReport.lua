local view = require("app.ui.view.exerciseReport")
local model = require("app.domain.exerciseReport")

local function designPostHandleOfReport(cfg, report)
	local greenWrap = view.WrapTextToColor(cfg.Succ, cfg.Default)
	local redWrap = view.WrapTextToColor(cfg.Fail, cfg.Default)

	return {
		Good = {
			Value = report.Good,
			StyleWrapp = nil,
		},

		Fixed = {
			Value = report.Fixed,
			StyleWrap = function(txt)
				if report.Fixed == 0 and report.Errors == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},

		Errors = {
			Value = report.Errors,
			StyleWrap = function(txt)
				if report.Errors == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},

		TimeTotal = {
			Value = report.TimeTotal,
			StyleWrap = nil,
		},

		TimeLostOnErrors = {
			Value = report.TimeLostOnErrors,
			StyleWrap = function(txt)
				if report.TimeLostOnErrors == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},

		ErrorsRatio = {
			Value = report.ErrorsRatio,
			StyleWrap = function(txt)
				if report.ErrorsRatio == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},

		WastedTimeRatio = {
			Value = report.WastedTimeRatio,
			StyleWrap = function(txt)
				if report.WastedTimeRatio == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},
	}
end

local exerciseReportController = function(baseControllerInvoke, cfg, storage, topicData, topicWalkthrough)
	local report = model.BuildReport(storage, topicData, topicWalkthrough)
	local styledReport = designPostHandleOfReport(cfg, report)

	return {
		Load = function()
			view:Load(styledReport)
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
	New = exerciseReportController,
}

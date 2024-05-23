local overlayableChar = require("app.domain.lexic.char")
local view = require("app.ui.view.excercise")
local model = require("app.domain.excercise")
local pp = require("utils.print.pretty")

local mapStatusToColors = {}
local function initTextColor(cfg)
	mapStatusToColors[overlayableChar.Statuses().Nil] = view.WrapTextToColor(cfg.Default, cfg.Default)
	mapStatusToColors[overlayableChar.Statuses().Succ] = view.WrapTextToColor(cfg.Succ, cfg.Default)
	mapStatusToColors[overlayableChar.Statuses().Fail] = view.WrapTextToColor(cfg.Fail, cfg.Default)
	mapStatusToColors[overlayableChar.Statuses().Fixed] = view.WrapTextToColor(cfg.Fixed, cfg.Default)
end

local function convertSymbolDTO(update)
	local res = {}

	if update == nil then
		return res
	end

	local wrapper = mapStatusToColors[update.Status]

	local val = update.Value
	local failed = overlayableChar.CompareStatuses(update.Status, overlayableChar.Statuses().Fail)
	local fixed = overlayableChar.CompareStatuses(update.Status, overlayableChar.Statuses().Fixed)
	if val == " " and (failed or fixed) then
		val = "·"
	end

	table.insert(res, {
		x = update.Position.CharNum,
		y = update.Position.LineNum,
		data = wrapper(val),
	})
	table.insert(res, {
		x = update.Jump.CharNum,
		y = update.Jump.LineNum,
		data = "",
	})

	return res
end

local excerciseController = function(baseControllerInvoke, cfg, text)
	initTextColor(cfg)
	local winsize = view:CurrentWinsize()
	local excercise = model:New(text, winsize.MaxY)

	return {
		Load = function()
			-- todo leaking abstraction - connection via plain text
			view:Load(excercise:PlainText())
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

		Default = function(_, signalChar)
			local domainDTO = excercise:TypeSymbol(signalChar)
			local viewDTO = convertSymbolDTO(domainDTO)
			view:Refresh(viewDTO)

			if excercise:Done() then
				baseControllerInvoke:Close()
				return
			end
		end,

		--  todo make backspace const
		[string.char(127)] = function(_, _)
			local domainDTO = excercise:EraseSymbol()
			local viewDTO = convertSymbolDTO(domainDTO)
			view:Refresh(viewDTO)
		end,

		-- todo make esc const
		[string.char(27)] = function(_, signalChar)
			baseControllerInvoke:Close()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, _) end,
	}
end

return {
	New = excerciseController,
}

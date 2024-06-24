local tty = require("app.ui.tty.tty")
local elementCross = require("app.ui.view.standardComponents.cross")
local elementList = require("app.ui.view.standardComponents.list")

local function insertIntoTemplate(base, insertion, offsetIdx)
	local insertionLen = utf8.len(tty.DropColorWrap(insertion))

	local prefix = base:sub(1, utf8.offset(base, offsetIdx))
	local suffix = base.sub(base, utf8.offset(base, offsetIdx + insertionLen + 2))

	return prefix .. insertion .. suffix
end

-- todo must be extracted and tested
local function trimText(txt, maxLength)
	if utf8.len(txt) > maxLength then
		local truncatedLen = maxLength - 3
		local bytePosition = utf8.offset(txt, truncatedLen + 1) - 1
		return txt:sub(1, bytePosition) .. "..."
	else
		return txt
	end
end

local function render(trimmedList)
	local list = trimmedList:ToLines()

	local templateTop = {
		"╔══════════════════════════════════════════════════╗",
		"║ ---------------  Training Plans  --------------- ║",
		"╠══════════════════════════════════════════════════╣",
		"║ ┌──────────────────────────────────────────────┐ ║",
	}

	local templateRow = {
		"║ │                                              │ ║",
		"║ ├──────────────────────────────────────────────┤ ║",
	}

	local templateBottom = {
		"║ └──────────────────────────────────────────────┘ ║",
		"╚══════════════════════════════════════════════════╝",
	}

	local lines = {}
	table.move(templateTop, 1, #templateTop, 1, lines)
	for _, v in ipairs(list) do
		table.insert(lines, insertIntoTemplate(templateRow[1], v, 5))
		table.insert(lines, templateRow[2])
	end
	if #lines > #templateTop then
		table.remove(lines, #lines)
	end
	table.insert(lines, templateBottom[1])
	table.insert(lines, templateBottom[2])

	local winsize = tty:WinSize()
	local offseted = elementCross.OffsetRowPool(lines, winsize)

	for _, row in pairs(offseted) do
		tty.Jump(row.X, row.Y)
		tty.Print(row.line)
	end
end

local listOfPlans = nil
local wordMaxWidth = 44

return {
	Close = function()
		tty.ClearScreen()
		tty.Jump(1, 1)
		os.execute("tput cnorm")
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function(self, colorsCfg, list)
		os.execute("tput civis")
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.ClearScreen()

		for idx = 1, #list, 1 do
			list[idx].Value = trimText(list[idx].Value, wordMaxWidth)
		end

		if listOfPlans == nil then
			listOfPlans = elementList.NewTrimmedList(colorsCfg.Active, colorsCfg.Default, list, 7)
		end

		render(listOfPlans)
	end,

	PickPrev = function(self)
		listOfPlans.PickPrev()
		render(listOfPlans)
	end,

	PickNext = function(self)
		listOfPlans.PickNext()
		render(listOfPlans)
	end,

	GetCurrent = function(self)
		return listOfPlans.GetCurrent()
	end,
}

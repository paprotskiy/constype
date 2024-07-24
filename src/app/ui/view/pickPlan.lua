local tty = require("app.ui.tty.tty")
local element_cross = require("app.ui.view.standardComponents.cross")
local element_list = require("app.ui.view.standardComponents.list")

local function insertIntoTemplate(base, insertion, offsetIdx)
	local insertionLen = utf8.len(tty.drop_color_wrap(insertion))

	local prefix = base:sub(1, utf8.offset(base, offsetIdx))
	local suffix = base.sub(base, utf8.offset(base, offsetIdx + insertionLen + 2))

	return prefix .. insertion .. suffix
end

-- todo must be extracted and tested
local function trimText(txt, max_length)
	if utf8.len(txt) > max_length then
		local truncated_len = max_length - 3
		local byte_position = utf8.offset(txt, truncated_len + 1) - 1
		return txt:sub(1, byte_position) .. "..."
	else
		return txt
	end
end

local function render(trimmed_list)
	local list = trimmed_list:to_lines()

	local template_top = {
		"╔══════════════════════════════════════════════════╗",
		"║ ---------------  Training Plans  --------------- ║",
		"╠══════════════════════════════════════════════════╣",
		"║ ┌──────────────────────────────────────────────┐ ║",
	}

	local template_row = {
		"║ │                                              │ ║",
		"║ ├──────────────────────────────────────────────┤ ║",
	}

	local template_bottom = {
		"║ └──────────────────────────────────────────────┘ ║",
		"╚══════════════════════════════════════════════════╝",
	}

	local lines = {}
	table.move(template_top, 1, #template_top, 1, lines)
	for _, v in ipairs(list) do
		table.insert(lines, insertIntoTemplate(template_row[1], v, 5))
		table.insert(lines, template_row[2])
	end
	if #lines > #template_top then
		table.remove(lines, #lines)
	end
	table.insert(lines, template_bottom[1])
	table.insert(lines, template_bottom[2])

	local winsize = tty:wins_size()
	local offseted = element_cross.offset_row_pool(lines, winsize)

	for _, row in pairs(offseted) do
		tty.jump(row.X, row.Y)
		tty.print(row.line)
	end
end

local list_of_plans = nil
local word_max_width = 44

return {
	close = function()
		tty.clear_screen()
		tty.jump(1, 1)
		os.execute("tput cnorm")
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	load = function(self, colorsCfg, list)
		os.execute("tput civis")
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.clear_screen()

		for idx = 1, #list, 1 do
			list[idx].value = trimText(list[idx].value, word_max_width)
		end

		if list_of_plans == nil then
			list_of_plans = element_list.new_trimmed_list(colorsCfg.Active, colorsCfg.default, list, 7)
		end

		render(list_of_plans)
	end,

	pick_prev = function(self)
		list_of_plans.pick_prev()
		render(list_of_plans)
	end,

	pick_next = function(self)
		list_of_plans.pick_next()
		render(list_of_plans)
	end,

	get_current = function(self)
		return list_of_plans.get_current()
	end,
}

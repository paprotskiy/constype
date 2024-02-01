local first = {
	__isKilled = false,
	Start = function(self)
		os.execute("stty -icanon") -- put TTY in raw mode
	end,

	Kill = function(self)
		self.__isKilled = true
		os.execute("stty icanon") -- at end of program, put TTY back to normal mode
	end,

	ProtectedRawRun = function(self, runtime)
		while not self.__isKilled do
			local ok, errMsg = pcall(runtime)
			if not ok then
				print("failed")
				print(errMsg)
				self:Kill()
			end
		end
	end,

	__colorCommandBuilder = function(color)
		return "\27[" .. color .. "m"
	end,

	PrintText = function(self, text, color)
		local setColor = self.__colorCommandBuilder(color)
		local resetColorToStandard = self.__colorCommandBuilder(0)
		io.write(setColor .. text .. resetColorToStandard)
	end,
}

local second = {}

return first

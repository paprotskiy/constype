return {
	NewTest = function(name, test)
		return {
			name = name,
			exec = test,
			-- exec = function()
			-- 	local res = test()
			-- 	if res == nil then
			-- 		return tostring(res)
			-- 	end
			-- end,
		}
	end,

	NewTestErr = function(message)
		return {
			ErrMessage = message,
		}
	end,
}

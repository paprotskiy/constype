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

	GetTestErrMessage = function(err, allowNil)
		if err == nil and allowNil then
			return nil
		elseif err == nil and not allowNil then
			error("nilNotAllowed")
		end

		local msg = err.ErrMessage
		if msg == nil then
			error("not an test error")
		end

		return msg
	end,
}

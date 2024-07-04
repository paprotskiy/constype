return {
	newTest = function(name, test)
		return {
			name = name,
			exec = test,
		}
	end,

	newTestErr = function(message)
		return {
			ErrMessage = message,
		}
	end,
}

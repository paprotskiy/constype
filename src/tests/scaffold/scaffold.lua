return {
	NewTest = function(name, test)
		return {
			name = name,
			exec = test,
		}
	end,

	NewTestErr = function(message)
		return {
			ErrMessage = message,
		}
	end,
}

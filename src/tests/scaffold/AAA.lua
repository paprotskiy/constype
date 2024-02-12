-- Arrange-Act-Accert scaffold
--
--
package.path = package.path .. ";../?.lua"
local scaffold = require("scaffold.scaffold")

local function addAssert(asserts, comparator, expectedOutput, expectedErr, sut, ...)
	local arg = { ... }

	table.insert(asserts, function()
		local actualOutput = nil
		local _, actualErr = pcall(function()
			actualOutput = sut(table.unpack(arg))
		end)

		local compareRes = nil
		local _, compareErr = pcall(function()
			compareRes = comparator(expectedOutput, expectedErr, actualOutput, actualErr)
		end)

		if compareErr ~= nil then
			return scaffold.NewTestErr("comparator crashed: " .. compareErr)
		end

		return compareRes
	end)
end

local defaultComparator = function(expectedOutput, expectedErr, actualOutput, actualErr)
	if actualErr ~= nil then
		return scaffold.NewTestErr("an error was catched: " .. tostring(actualErr))
	end

	if expectedOutput ~= actualOutput then
		local msg = string.format('expected "%s", got "%s"', expectedOutput, actualOutput)
		return scaffold.NewTestErr(msg)
	end

	return nil
end

local errMustRaise = function(expectedOutput, expectedErr, actualOutput, actualErr)
	if actualErr ~= nil then
		return nil
	end

	return scaffold.NewTestErr("raising error expected, but not occurred")
end

local function NewSUT()
	return {
		__sut = nil,
		__asserts = {},

		Exec = function(self)
			if type(self.__sut) ~= "function" then
				return scaffold.NewTestErr("SUT is not specified or not a function")
			end

			if #self.__asserts == 0 then
				return scaffold.NewTestErr("asserts are not specified")
			end

			for idx, assert in pairs(self.__asserts) do
				local err = assert()
				if err ~= nil then
					-- todo implement wrapping
					return scaffold.NewTestErr("assert #" .. tostring(idx) .. " failed: " .. err.ErrMessage)
				end
			end

			return nil
		end,

		Build = function(self)
			return function()
				return self:Exec()
			end
		end,

		SetSUT = function(self, func)
			self.__sut = func
			return self
		end,

		AssertSutWithParams = function(self, ...)
			local arg = { ... }
			return {
				DetailedComparation = function(_, expectedOutput, expectedErr, comparator)
					addAssert(self.__asserts, comparator, expectedOutput, expectedErr, self.__sut, table.unpack(arg))
					return self
				end,

				Equal = function(selfCheck, expectedOutput, comparator)
					comparator = comparator or defaultComparator
					return selfCheck:DetailedComparation(expectedOutput, nil, comparator)
				end,

				ThrowsError = function(selfCheck)
					return selfCheck:DetailedComparation(nil, nil, errMustRaise)
				end,
			}
		end,
	}
end

return {
	NewForSUT = function(sut)
		return NewSUT():SetSUT(sut)
	end,
}

-- Arrange-Act-Accert scaffold
--
--
package.path = package.path .. ";../?.lua"
local scaffold = require("scaffold.scaffold")
local equal = require("utils.equal.deepEqual")

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
			return scaffold.newTestErr("comparator crashed: " .. compareErr)
		end

		return compareRes
	end)
end

local function defaultComparator(expectedOutput, expectedErr, actualOutput, actualErr)
	if actualErr ~= nil then
		return scaffold.newTestErr("an error was catched: " .. tostring(actualErr))
	end

	if expectedOutput ~= actualOutput then
		local msg = string.format('expected "%s", got "%s"', expectedOutput, actualOutput)
		return scaffold.newTestErr(msg)
	end

	return nil
end

local function tableComparator(expectedOutput, expectedErr, actualOutput, actualErr)
	if actualErr ~= nil then
		return scaffold.newTestErr("error not expected, but got " .. actualErr)
	end

	local errMsg = equal.DeepEqualIgnoreFuncs(expectedOutput, actualOutput)

	if errMsg == nil then
		return nil
	end

	return scaffold.newTestErr(errMsg)
end

local errMustRaise = function(expectedOutput, expectedErr, actualOutput, actualErr)
	if actualErr ~= nil then
		return nil
	end

	return scaffold.newTestErr("raising error expected, but not occurred")
end

local function newSUT()
	return {
		__sut = nil,
		__asserts = {},

		Exec = function(self)
			if type(self.__sut) ~= "function" then
				return scaffold.newTestErr("SUT is not specified or not a function")
			end

			if #self.__asserts == 0 then
				return scaffold.newTestErr("asserts are not specified")
			end

			for idx, assert in pairs(self.__asserts) do
				local err = assert()
				if err ~= nil then
					-- todo implement wrapping
					return scaffold.newTestErr("assert #" .. tostring(idx) .. " failed: " .. err.ErrMessage)
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
	newForSUT = function(sut)
		return newSUT():SetSUT(sut)
	end,

	TableComparator = tableComparator,
}

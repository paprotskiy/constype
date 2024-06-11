-- local topic = require("app.domain.lexic.topic")
local cjson = require("cjson")
local char = require("app.domain.lexic.char")
local period = require("app.time.period")

local function setPrecision(value, numOfSymbolsAfterDot)
	local integerPart = math.floor(value)
	local fractionalPart = value - integerPart

	local k = 10 ^ numOfSymbolsAfterDot
	local afterComma = math.floor(fractionalPart * k) / k
	return integerPart + afterComma
end
local function badRatio(good, bad)
	return 1 - good / (good + bad)
end

local function tableCopyWithoutFunctions(data)
	local res = {}
	for k, v in pairs(data) do
		if type(v) == "table" then
			res[k] = tableCopyWithoutFunctions(v)
		elseif type(v) ~= "function" then
			res[k] = v
		end
	end
	return res
end

return {
	BuildReport = function(storage, topicData, topicWalkthrough)
		local chars = topicWalkthrough:ExportAsSingleLine():AllChars()
		local statuses = char.Statuses()

		local good = 0
		local fixed = 0
		local bad = 0
		local goodTiming = period.New(0)
		local errTiming = period.New(0)
		for idx, ch in pairs(chars) do
			local timing = char.Timing(ch)
			goodTiming:Add(timing.Ok)
			errTiming:Add(timing.Bad)

			if char:CompareCharStatus(ch, statuses.Succ) then
				good = good + 1
			elseif char:CompareCharStatus(ch, statuses.Fixed) then
				fixed = fixed + 1
			else
				bad = bad + 1
			end
		end

		local errRatio = 1
		local wastedTimeRatio = 1
		if bad == 0 then
			errRatio = badRatio(good, fixed + bad)
			wastedTimeRatio = badRatio(goodTiming:Milliseconds(), errTiming:Milliseconds())
		end
		local timeTotalMs = period.New(0):Add(goodTiming):Add(errTiming):Milliseconds()
		local timeLostOnErrorsMs = errTiming:Milliseconds()

		local saveToStorage = function()
			local walkthroughWithoutFuncs = tableCopyWithoutFunctions(topicWalkthrough)
			local json = cjson.encode(walkthroughWithoutFuncs)
			local topicId = topicData.TopicId
			local endTime = os.time()
			local startTime = endTime - timeTotalMs / 1000
			local success = fixed + bad < 10
			storage.SaveTrainingRun(topicId, startTime, endTime, success, json)
		end
		saveToStorage()

		return {
			Good = good,
			Fixed = fixed,
			Errors = bad,
			TimeTotal = setPrecision(timeTotalMs / 1000, 2),
			TimeLostOnErrors = setPrecision(timeLostOnErrorsMs / 1000, 2),
			ErrorsRatio = setPrecision(errRatio, 3),
			WastedTimeRatio = setPrecision(wastedTimeRatio, 3),
		}
	end,
}

package.path = package.path .. ";../?.lua"

local file = require("app.io.fileSystem.file")
local connBuilder = require("app.repo.conn")
local repoBuilder = require("app.repo.repo")
local toAscii = require("utils.ascii")
local sqlDir = "./repo/sql"

-------------------------------------- create db and tables -------------------------------------
connBuilder.CreateDbIfNotExists()

local conn = connBuilder.PgConnection()
local repo = repoBuilder.New(conn)
repo.ApplyMigrationsIfNotExists()
-------------------------------------- create db and tables -------------------------------------

---------------------------------- read big text and get topics ---------------------------------
local function getTopicsFromBigFile(address)
	local function endsWithSymbol(str, symb)
		return str:sub(- #symb) == symb
	end

	local function trim(str)
		str = str:gsub("\n", "")
		str = str:gsub("\r", "")
		return toAscii.UnicodeToAscii(str)
	end

	local rows = file.ReadFileLines(address)

	local par = ""
	local paragraphs = {}
	for _, part in ipairs(rows) do
		par = par .. part .. "\n"
		if endsWithSymbol(part, ".") then
			table.insert(paragraphs, trim(par))
			par = ""
		elseif not endsWithSymbol(part, " ") then
			par = par .. " "
		end
	end

	return paragraphs
end
---------------------------------- read big text and get topics ---------------------------------

------------------------------------------ seed tables ------------------------------------------
local testId = repo.CreatePlan("test")
repo.CreateTopic(testId, "test", 1)

local testId = repo.CreatePlan("test-2")
repo.CreateTopic(testId, "test2", 1)

local testId = repo.CreatePlan("test-3")
repo.CreateTopic(testId, "test3", 1)

local testId = repo.CreatePlan("test-4")
repo.CreateTopic(testId, "test4", 1)

local testId = repo.CreatePlan("test-5")
repo.CreateTopic(testId, "test5", 1)

local testId = repo.CreatePlan("test-6")
repo.CreateTopic(testId, "test6", 1)

local testId = repo.CreatePlan("test-7")
repo.CreateTopic(testId, "test7", 1)

local testId = repo.CreatePlan("test-8")
repo.CreateTopic(testId, "test8", 1)

local testId = repo.CreatePlan("test-9")
repo.CreateTopic(testId, "test9", 1)

local parts = getTopicsFromBigFile("../../texts/big.txt")
local planId = repo.CreatePlan("book")
for k, v in ipairs(parts) do
	repo.CreateTopic(planId, v, k)
end
------------------------------------------ seed tables ------------------------------------------

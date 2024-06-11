package.path = package.path .. ";../?.lua"

local file = require("app.io.fileSystem.file")
local connBuilder = require("app.repo.conn")
local repoBuilder = require("app.repo.repo")
local toAscii = require("utils.ascii")
local sqlDir = "./repo-sql"

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
local parts = getTopicsFromBigFile("../../texts/big.txt")
local planId = repo.CreatePlan("book")
for k, v in ipairs(parts) do
	repo.CreateTopic(planId, v, k)
end
------------------------------------------ seed tables ------------------------------------------

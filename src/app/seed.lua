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

----------------------------------------- create topics -----------------------------------------
local function getFilesInDirectory(directory)
	local files = {}
	local p = io.popen('find "' .. directory .. '" -type f')
	for file in p:lines() do
		table.insert(files, file)
	end
	p:close()

	return files
end

local function trimString(str, delimiter)
	local first = nil
	local last = nil
	local pattern = string.format("([^%s]+)", delimiter)
	for part in string.gmatch(str, pattern) do
		if first == nil then
			first = part
		end
		last = part
	end
	return first, last
end

local function readAllTopicsFromDisc()
	local parts = {}
	local filePaths = getFilesInDirectory("../../texts/parts/")
	for _, filePath in ipairs(filePaths) do
		-- ../../texts/parts/1350.txt
		local _, filename = trimString(filePath, "/")
		local filenameNoExtention, _ = trimString(filename, ".")
		local order = tonumber(filenameNoExtention)

		local data = file.ReadFile(filePath)

		parts[order] = toAscii.UnicodeToAscii(data)
	end
	os.execute("sleep 5")
	return parts
end

------------------------------------------ save topics ------------------------------------------

local planId = repo.CreatePlan("book")

local parts = readAllTopicsFromDisc()
for k, v in ipairs(parts) do
	repo.CreateTopic(planId, v, k)
end

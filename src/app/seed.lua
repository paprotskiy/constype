package.path = package.path .. ";../?.lua"

local file = require("app.io.fileSystem.file")
local connBuilder = require("app.repo.conn")
local repoBuilder = require("app.repo.repo")
local toAscii = require("utils.ascii")
local sqlDir = "./repo/sql"

-------------------------------------- create db and tables -------------------------------------
connBuilder.create_db_if_not_exists()

local conn = connBuilder.pg_connection()
local repo = repoBuilder.new(conn)
repo.apply_migrations_if_not_exists()
-------------------------------------- create db and tables -------------------------------------

---------------------------------- read big text and get topics ---------------------------------
local function ends_with_symbols(str, symb)
	return str:sub(- #symb) == symb
end

local function get_topics_from_big_file(address)
	local function trim(str)
		str = str:gsub("\n", "")
		str = str:gsub("\r", "")
		return toAscii.unicode_to_ascii(str)
	end

	local rows = file.read_file_lines(address)

	local par = ""
	local paragraphs = {}
	for _, part in ipairs(rows) do
		par = par .. part .. "\n"
		if ends_with_symbols(part, ".") then
			table.insert(paragraphs, trim(par))
			par = ""
		elseif not ends_with_symbols(part, " ") then
			par = par .. " "
		end
	end

	return paragraphs
end
---------------------------------- read big text and get topics ---------------------------------

------------------------------------------ seed tables ------------------------------------------
local testId = repo.create_plan("test")
repo.create_topic(testId, "test", 1)

local testId = repo.create_plan("test-2")
repo.create_topic(testId, "test2", 1)

local testId = repo.create_plan("test-3")
repo.create_topic(testId, "test3", 1)

local testId = repo.create_plan("test-4")
repo.create_topic(testId, "test4", 1)

local testId = repo.create_plan("test-5")
repo.create_topic(testId, "test5", 1)

local testId = repo.create_plan("test-6")
repo.create_topic(testId, "test6", 1)

local testId = repo.create_plan("test-7")
repo.create_topic(testId, "test7", 1)

local testId = repo.create_plan("test-8")
repo.create_topic(testId, "test8", 1)

local testId = repo.create_plan("test-9")
repo.create_topic(testId, "test9", 1)

local parts = get_topics_from_big_file("../../texts/big.txt")
local plan_id = repo.create_plan("book")
for k, v in ipairs(parts) do
	repo.create_topic(plan_id, v, k)
end
------------------------------------------ seed tables ------------------------------------------

package.path = package.path .. ";../?.lua"
local pgmoon = require("pgmoon")
local cfg = require("app.cfg.config")
local pgConfig = cfg.PG

local pg = pgmoon.new({
	host = pgConfig.PgHost,
	port = pgConfig.PgPort,
	database = pgConfig.PgDatabase,
	user = pgConfig.PgUser,
	password = pgConfig.PgPassword,
})

local pgDefault = pgmoon.new({
	host = pgConfig.PgHost,
	port = pgConfig.PgPort,
	database = "postgres",
	user = pgConfig.PgUser,
	password = pgConfig.PgPassword,
})

local function databaseExists(conn, dbName)
	local query = string.format("SELECT EXISTS (SELECT 1 FROM pg_database WHERE datname = '%s')", dbName)
	local cur = assert(conn:query(query))

	local res = cur[1]["exists"]
	if type(res) ~= "boolean" then
		error("unexpected result type")
	end

	return res
end

local function createDatabase(conn, dbName)
	local query = string.format([[create database "%s"]], dbName)
	assert(conn:query(query))
end

return {
	CreateDbIfNotExists = function()
		assert(pgDefault:connect())

		local dbName = pgConfig.PgDatabase
		local exists = databaseExists(pgDefault, dbName)
		if not exists then
			createDatabase(pgDefault, dbName)
		end

		pgDefault:disconnect()
	end,

	PgConnection = function()
		assert(pg:connect())
		pg:settimeout(24 * 60 * 60 * 1000)
		return pg
	end,
}

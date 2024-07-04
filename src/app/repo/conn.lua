package.path = package.path .. ";../?.lua"
local pgmoon = require("pgmoon")
local cfg = require("app.cfg.config")
local pg_config = cfg.pg

local pg = pgmoon.new({
	host = pg_config.pg_host,
	port = pg_config.pg_port,
	database = pg_config.pg_database,
	user = pg_config.pg_user,
	password = pg_config.pg_password,
})

local pg_default = pgmoon.new({
	host = pg_config.pg_host,
	port = pg_config.pg_port,
	database = "postgres",
	user = pg_config.pg_user,
	password = pg_config.pg_password,
})

local function database_exists(conn, dbName)
	local query = string.format("SELECT EXISTS (SELECT 1 FROM pg_database WHERE datname = '%s')", dbName)
	local cur = assert(conn:query(query))

	local res = cur[1]["exists"]
	if type(res) ~= "boolean" then
		error("unexpected result type")
	end

	return res
end

local function create_database(conn, dbName)
	local query = string.format([[create database "%s"]], dbName)
	assert(conn:query(query))
end

return {
	create_db_if_not_exists = function()
		assert(pg_default:connect())

		local dbName = pg_config.pg_database
		local exists = database_exists(pg_default, dbName)
		if not exists then
			create_database(pg_default, dbName)
		end

		pg_default:disconnect()
	end,

	pg_connection = function()
		assert(pg:connect())
		pg:settimeout(24 * 60 * 60 * 1000)
		return pg
	end,
}

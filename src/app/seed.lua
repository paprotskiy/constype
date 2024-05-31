package.path = package.path .. ";../?.lua"

local conn = require("app.repo.conn")
local migrations = require("app.repo.migrations")
local sqlDir = "./repo-sql"

conn:MigrateIfNotExists()
local pgConn = conn:PgConnection()
-- migrations.Apply(sqlDir)

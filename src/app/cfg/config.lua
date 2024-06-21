local customAssert = require("utils.assert")

local errs = {}
local function readEnv(key)
	local val = os.getenv(key)
	if #val == 0 then
		table.insert(errs, 'env "' .. key .. '" not found')
		return nil
	end

	return val
end

local function readNumEnv(key)
	local val = os.getenv(key)
	local num = tonumber(val)
	if num == nil then
		table.insert(errs, 'env "' .. key .. '" not found')
		return nil
	end

	return num
end

local function fillEnvs()
	local config = {
		TerminalColors = {
			Default = readEnv("COLOR_DEFAULT_IDX"),
			Succ = readEnv("COLOR_SUCC_IDX"),
			Fail = readEnv("COLOR_FAIL_IDX"),
			Fixed = readEnv("COLOR_FIXED_IDX"),
		},
		thresholds = {
			Errs = readNumEnv("ERRS_THRESHOLD"),
			Fixed = readNumEnv("FIXED_THRESHOLD"),
		},
		pg = {
			PgHost = readEnv("PG_HOST"),
			PgPort = readEnv("PG_PORT"),
			PgDatabase = readEnv("PG_DATABASE"),
			PgUser = readEnv("PG_USER"),
			PgPassword = readEnv("PG_PASSWORD"),
			PgSslMode = readEnv("PG_SSL_MODE"),
		},
	}

	customAssert(#errs == 0, table.concat(errs, "\n"))
	return config
end

return fillEnvs()

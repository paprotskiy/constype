local custom_assert = require("utils.assert")

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
		terminal_colors = {
			default = readEnv("COLOR_DEFAULT_IDX"),
			succ = readEnv("COLOR_SUCC_IDX"),
			fail = readEnv("COLOR_FAIL_IDX"),
			fixed = readEnv("COLOR_FIXED_IDX"),
			Active = readEnv("COLOR_ACTIVE_IDX"),
		},
		thresholds = {
			errs = readNumEnv("ERRS_THRESHOLD"),
			fixed = readNumEnv("FIXED_THRESHOLD"),
		},
		pg = {
			pg_host = readEnv("PG_HOST"),
			pg_port = readEnv("PG_PORT"),
			pg_database = readEnv("PG_DATABASE"),
			pg_user = readEnv("PG_USER"),
			pg_password = readEnv("PG_PASSWORD"),
			pg_ssl_mode = readEnv("PG_SSL_MODE"),
		},
	}

	custom_assert(#errs == 0, table.concat(errs, "\n"))
	return config
end

return fillEnvs()

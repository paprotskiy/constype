local file = require("app.io.fileSystem.file")
local sqlDir = "./repo/sql"

return {
	New = function(pgConn)
		return {
			ApplyMigrationsIfNotExists = function()
				local query = file.ReadFile(sqlDir .. "/migrations.sql")

				assert(pgConn:query(query))
			end,

			CreatePlan = function(title)
				local query = [[
               INSERT INTO plans (
                  "title"
               ) VALUES (
                  $1
               ) RETURNING id
            ]]
				local raw = assert(pgConn:query(query, title))

				return raw[1]["id"]
			end,

			GetPlans = function()
				local query = [[
               select
                  "id" as id,
                  "title" as title
               from plans
            ]]
				local raw = assert(pgConn:query(query))

				local res = {}
				for _, part in ipairs(raw) do
					table.insert(res, {
						Id = part["id"],
						Title = part["title"],
					})
				end
				return res
			end,

			CreateTopic = function(planId, topic, order)
				local query = [[
               INSERT INTO topics (
                  "plan_id",
                  "topic",
                  "order"
               ) VALUES (
                  $1::uuid,
                  $2,
                  $3
               ) RETURNING id
            ]]
				local raw = assert(pgConn:query(query, planId, topic, order))

				return raw[1]["id"]
			end,

			GetFirstUnfinishedTopic = function(planId)
				local query = [[
               SELECT
						topic.id as topic_id,
						plan.id,
						plan.title as plan_title,
						topic.order,
						topic.topic
               FROM topics AS topic
               INNER JOIN plans AS plan ON topic.plan_id = plan.id
               LEFT JOIN training_runs AS run ON run.topic_id = topic.id
               LEFT JOIN training_runs AS run2 ON run2.topic_id = topic.id AND run2.success = true
               WHERE
	               run2.id IS null and
	               plan.id = $1::uuid
               ORDER BY topic.order
               LIMIT 1
            ]]

				local raw = assert(pgConn:query(query, planId))
				if #raw == 0 then
					return nil
				end

				return {
					TopicId = raw[1]["topic_id"],
					Topic = raw[1]["topic"],
					Order = raw[1]["order"],
					-- PlanTitle = raw[1]["plan_title"],
				}
			end,

			SaveTrainingRun = function(topicId, startTime, endTime, success, json)
				local query = [[
               INSERT INTO training_runs (
                  "topic_id",
                  "started",
                  "ended",
                  "success",
                  "raw_data"
               ) VALUES (
                  $1::uuid,
                  to_timestamp($2),
                  to_timestamp($3),
                  $4,
                  $5::jsonb
               ) RETURNING id
            ]]
				local raw = assert(pgConn:query(query, topicId, startTime, endTime, success, json))

				return raw[1]["id"]
			end,
		}
	end,
}

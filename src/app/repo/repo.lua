local file = require("app.io.fileSystem.file")
local conn = require("app.repo.conn")
-- local sqlDir = "./repo-sql"

return {
   New = function(pgConn)
      return {
         ApplyMigrationsIfNotExists = function()
            -- local request = file.ReadFile(sqlDir .. "/migrations.sql")

            local query = [[
               create extension if not exists dblink;
               create extension if not exists "uuid-ossp";

               create table if not exists plans
               (
                  "id"       uuid     default uuid_generate_v4() not null primary key,
                  "title"    text                                not null unique
               );

               create table if not exists topics
               (
                  "id"       uuid     default uuid_generate_v4() not null primary key,
                  "plan_id"  uuid                                not null references plans,
                  "topic"    text                                not null,
                  "order"    integer                             not null,

                  unique ("plan_id", "order")
               );

               create table if not exists training_runs
               (
                  "id"       uuid     default uuid_generate_v4() not null primary key,
                  "topic_id" uuid                                not null references topics,
                  "started"  timestamp with time zone            not null,
                  "ended"    timestamp with time zone            not null,
                  "success"  boolean                             not null,
                  "raw_data" jsonb                               not null
               );
            ]]

            assert(pgConn:query(query))
         end,

         CreatePlan = function(title)
            local query = [[
            insert into plans (
               "title"
            ) values (
               $1
            ) returning id
            ]]
            local raw = assert(pgConn:query(query, title))

            return raw[1]["id"]
         end,

         CreateTopic = function(planId, topic, order)
            local query = [[
               insert into topics (
                  "plan_id",
                  "topic",
                  "order"
               ) values (
                  $1::uuid,
                  $2,
                  $3
               ) returning id
               ]]
            local raw = assert(pgConn:query(query, planId, topic, order))

            return raw[1]["id"]
         end,

         GetFirstUnfinishedTopic = function(planId)
            local query = [[
                  select
                  --	distinct on (topic.order)
	                  topic.id as topic_id,
	                  plan.id,
	                  plan.title as plan_title,
	                  topic.order,
                      topic.topic
                  FROM topics AS topic
                  INNER join plans AS plan ON topic.plan_id = plan.id
                  LEFT JOIN training_runs AS run ON run.topic_id = topic.id
                  LEFT JOIN training_runs AS run2 ON run2.topic_id = topic.id AND run2.success = true
                  WHERE
	                  run2.id IS null and
	                  plan.id = $1::uuid
                  order by topic.order
                  limit 1
               ]]
            local raw = assert(pgConn:query(query, planId))

            assert(#raw == 1)
            return {
               TopicId = raw[1]["topic_id"],
               Topic = raw[1]["topic"],
               Order = raw[1]["order"],
               -- PlanTitle = raw[1]["plan_title"],
            }
         end,

         SaveTrainingRun = function(topicId, startTime, endTime, success, json)
            local query = [[
               insert into training_runs (
                  "topic_id",
                  "started",
                  "ended",
                  "success",
                  "raw_data"
               ) values (
                  $1::uuid,
                  to_timestamp($2),
                  to_timestamp($3),
                  $4,
                  $5::jsonb
               ) returning id
               ]]
            local raw = assert(pgConn:query(query, topicId, startTime, endTime, success, json))

            return raw[1]["id"]
         end,
      }
   end,
}

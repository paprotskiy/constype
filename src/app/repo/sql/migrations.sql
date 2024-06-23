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

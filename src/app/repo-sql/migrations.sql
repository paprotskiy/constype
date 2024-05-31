create extension if not exists dblink;
create extension if not exists "uuid-ossp";

create table if not exists plans
(
    "id"       uuid             not null primary key,
    "Title"    text             not null unique
);

create table if not exists topics
(
    "id"       uuid             not null primary key,
    "topic"    text             not null,
    "order"    integer          not null,
    "plan_id"  uuid             not null references plans,

    unique ("plan_id", "order")
);

create table if not exists training_runs
(
    "id"       uuid             not null primary key,
    "topic"    text             not null,
    "topic_id" uuid             not null references topics
);

create extension if not exists dblink;
create extension if not exists "uuid-ossp";

-- create database if not exists "constype-db";

DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database
      WHERE datname = 'constype-db'
   ) THEN
      PERFORM dblink_exec('dbname=' || current_database() || ' user=' || current_user, 'CREATE DATABASE "constype-db"');
   END IF;
END
$$;


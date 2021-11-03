\echo 'You need to use the following commands:'
\echo 'CREATE EXTENSION IF NOT EXISTS softvisio CASCADE;'
\echo 'ALTER EXTENSION softvisio UPDATE;'
\echo \quit

CREATE OR REPLACE PROCEDURE create_database ( _name text, _collate text DEFAULT 'ru_UA.UTF-8' ) AS $$
DECLARE
    _password text;
    _conn text;
BEGIN
    _conn := 'dbname=' || _name;

    -- check database exists
    IF EXISTS ( SELECT 1 FROM pg_database WHERE datname = _name ) THEN
        RAISE EXCEPTION 'Database already exists';
    END IF;

    -- create database
    PERFORM dblink_exec( 'dbname=' || current_database(), 'CREATE DATABASE ' || quote_ident( _name ) || ' ENCODING ''UTF8'' LC_COLLATE ' || quote_literal( _collate ) || ' LC_CTYPE ' || quote_literal( _collate ) || ' TEMPLATE template0', FALSE);

    -- if user is not exists
    IF NOT EXISTS ( SELECT 1 FROM pg_roles WHERE rolname = _name ) THEN
        -- generate password
        _password := ( SELECT translate( encode( gen_random_bytes( 16 ), 'base64' ), '+/=', '-_' ) AS password );

        RAISE NOTICE 'Password %', _password;

        -- create user
        PERFORM dblink_exec('dbname=' || current_database(), 'CREATE USER ' || quote_ident( _name ) || ' WITH ENCRYPTED PASSWORD ' || quote_literal( _password ), FALSE );
    ELSE
        RAISE NOTICE 'User already exists, you can set password manually';
    END IF;

    -- grant user permissions to create schemas
    PERFORM dblink_exec( 'dbname=' || current_database(), 'GRANT ALL PRIVILEGES ON DATABASE ' || quote_ident( _name ) || ' TO ' || quote_ident( _name ), FALSE );

    -- create schema
    PERFORM dblink_exec( _conn, 'CREATE SCHEMA AUTHORIZATION ' || quote_ident( _name ), FALSE );

    -- create extensions in "public" schema
    -- PERFORM dblink_exec(_conn, 'CREATE EXTENSION pgcrypto CASCADE', FALSE);
    -- PERFORM dblink_exec(_conn, 'CREATE EXTENSION timescaledb CASCADE', FALSE);
    -- PERFORM dblink_exec(_conn, 'CREATE EXTENSION pg_hashids CASCADE', FALSE);
END;
$$ LANGUAGE plpgsql;

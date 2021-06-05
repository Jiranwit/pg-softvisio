# Install / update / drop

```
CREATE EXTENSION "softvisio" CASCADE;

ALTER EXTENSION "softvisio" UPDATE;

DROP EXTENSION IF EXISTS "softvisio";
```

# Build

```
export PATH=/usr/pgsql-13/bin:$PATH

gmake USE_PGXS=1 install
```

# Procedures

## `create_database( \<database_name>, [\<collate>] )`

Default `collate` is `'ru_UA.UTF-8'`.

Example:

```
CALL create_database( 'test', 'ru_UA.UTF-8' );
```

## `update_extensions()`

Example:

```
CALL update_extensions();
```

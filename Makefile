EXTENSION = softvisio
DATA =	\
	softvisio--0.1.0.sql \
	softvisio--0.1.0--1.0.3.sql
	softvisio--1.0.3--2.0.0.sql

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

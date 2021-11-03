EXTENSION = softvisio
DATA =	\
	softvisio--0.0.0.sql \
	softvisio--0.0.0--1.0.0.sql \
	softvisio--1.0.0--1.1.0.sql

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

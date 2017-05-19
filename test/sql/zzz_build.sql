\set ECHO none
BEGIN;
\i test/pgxntool/psql.sql

CREATE EXTENSION IF NOT EXISTS cat_tools;

\echo
\echo INSTALL
\t
\i sql/extension_drop.sql

\echo # TRANSACTION INTENTIONALLY LEFT OPEN

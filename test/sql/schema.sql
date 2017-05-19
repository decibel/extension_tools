\set ECHO none
\set TEST_SCHEMA _test_ed
\i test/pgxntool/setup.sql

CREATE SCHEMA _test_ed_2;

SELECT plan(
  0

  + 2 -- has/drop

  + 2 -- create/has

  + 1 -- drop old test schema
);

SELECT has_table( :'TEST_SCHEMA', 'extension_drop__commands'::name);
SELECT lives_ok(
  $$DROP EXTENSION extension_drop$$
  , 'Drop extension'
);

\set TEST_SCHEMA_2 _test_ed_2
SELECT lives_ok(
  format( $$CREATE EXTENSION extension_drop SCHEMA %I$$, :'TEST_SCHEMA_2' )
  , 'Create extension in schema ' || :'TEST_SCHEMA_2'
);

SELECT has_table( :'TEST_SCHEMA_2', 'extension_drop__commands'::name);

SELECT lives_ok(
  format($$DROP SCHEMA %I$$, :'TEST_SCHEMA')
  , 'Drop schema ' || :'TEST_SCHEMA'
);

\i test/pgxntool/finish.sql

-- vi: expandtab sw=2 ts=2

\set ECHO none
\set TEST_SCHEMA _test_ed
\i test/pgxntool/setup.sql

CREATE SCHEMA _test_ed_2;

SELECT plan(
  0

  + 4 -- create/drop test ext

  + 2 -- has/drop

  + 2 -- create/has

  + 1 -- create test extension in specific schema

  + 2 -- update/verify

  + 1 -- drop old test schema
);

\i test/helpers/test_ext__create_drop.sql

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
  format( $$CREATE EXTENSION extension_drop_test SCHEMA %I$$, :'TEST_SCHEMA_2' )
  , 'Create test extension in ' || :'TEST_SCHEMA_2'
);

-- Ensure test schema 2 isn't in search_path
SET search_path = "$user", public, tap;

SELECT lives_ok(
  $$SELECT _test_ed_2.extension_drop__update('extension_drop_test', 'moo')$$
  , 'extension_drop__update()'
);
SELECT bag_eq(
  $$SELECT * FROM _test_ed_2.extension_drop__get('extension_drop_test')$$
  , $$SELECT 'extension_drop_test' AS extension_name, 'moo'$$
  , 'Verify extension_drop__get()'
);

SELECT lives_ok(
  format($$DROP SCHEMA %I$$, :'TEST_SCHEMA')
  , 'Drop schema ' || :'TEST_SCHEMA' || ' without cascade succeeds'
);

\i test/pgxntool/finish.sql

-- vi: expandtab sw=2 ts=2

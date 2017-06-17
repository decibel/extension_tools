\set ECHO none
\set TEST_SCHEMA _test_ed
\i test/pgxntool/setup.sql

SELECT plan(
  0
  
  + 1 -- Insert into test table

  + 1 -- Create test extension
  + 1 -- Verify test extension drop command
  + 1 -- Drop test extension
  + 1 -- Verify test table is empty

  + 1 -- Create test extension again
  -- Change search path
  + 2 -- Test __remove and add
  + 1 -- Drop fails
  + 2 -- __remove and drop succeeds
);

\i test/helpers/test_ext__insert.sql

SELECT lives_ok(
  'CREATE EXTENSION extension_drop_test'
  , 'Create test extension'
);

SELECT bag_eq(
  $$SELECT * FROM extension_drop__get('extension_drop_test')$$
  , $$SELECT 'extension_drop_test' AS extension_name, 'DELETE FROM extension_drop_test_table'$$
  , 'Verify extension_drop__get()'
);

SELECT lives_ok(
  $$DROP EXTENSION extension_drop_test$$
  , 'Drop test extension'
);

SELECT is_empty(
  $$SELECT * FROM $$ || :'TT'
  , :'TT' || ' is empty'
);

SELECT lives_ok(
  'CREATE EXTENSION extension_drop_test'
  , 'Create test extension again'
);

/*
 * Check search path for add command
 */
-- Intentionally change our search path
SET search_path = "$user", public, tap;

SELECT lives_ok(
  $$SELECT _test_ed.extension_drop__remove('extension_drop_test')$$
  , 'Drop extension command'
);
SELECT lives_ok(
  $$SELECT _test_ed.extension_drop__add('extension_drop_test', 'moo')$$
  , 'Add extension command'
);

SELECT throws_ok(
  $$DROP EXTENSION extension_drop_test$$
  , '42601'
  , 'syntax error at or near "moo"'
  , 'Dropping extension with bad command should fail'
);

SELECT lives_ok(
  $$SELECT _test_ed.extension_drop__remove('extension_drop_test')$$
  , 'Drop extension command'
);
SELECT lives_ok(
  $$DROP EXTENSION extension_drop_test$$
  , 'Drop test extension'
);

\i test/pgxntool/finish.sql

-- vi: expandtab sw=2 ts=2

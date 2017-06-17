SELECT lives_ok(
  'CREATE EXTENSION extension_drop_test'
  , 'Create test extension'
);

SELECT has_extension('extension_drop_test', 'Test extension exists');

SELECT lives_ok(
  $$DROP EXTENSION extension_drop_test$$
  , 'Drop test extension'
);

SELECT hasnt_extension('extension_drop_test', 'Test extension does not exist');

-- vi: expandtab sw=2 ts=2

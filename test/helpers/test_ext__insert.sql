SELECT lives_ok(
  format($$INSERT INTO %I VALUES(1);$$, :'TT')
  , 'Insert into ' || :'TT'
);

-- vi: expandtab sw=2 ts=2

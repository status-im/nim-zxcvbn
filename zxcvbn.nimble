mode = ScriptMode.Verbose

packageName   = "zxcvbn"
version       = "0.1.0"
author        = "Status Research & Development GmbH"
description   = "Nim bindings for the zxcvbn-c password strength estimator"
license       = "Apache License 2.0"
skipDirs      = @["tests"]

requires "nim >= 1.6.0",
         "testutils"

proc test(args, path: string) =
  if not dirExists "build":
    mkDir "build"
  exec "nim " & getEnv("TEST_LANG", "c") & " " & getEnv("NIMFLAGS") & " " & args &
    " --outdir:build -r --hints:off --styleCheck:usages --styleCheck:error --skipParentCfg " &
    path

task test, "Run all tests":
  test "--threads:off --mm:refc", "tests/test_all.nim"
  test "--threads:on  --mm:refc", "tests/test_all.nim"

  if (NimMajor, NimMinor) > (1, 6):
    test "--threads:off --mm:orc",  "tests/test_all.nim"
    test "--threads:on  --mm:orc",  "tests/test_all.nim"

mode = ScriptMode.Verbose

packageName   = "zxcvbn"
version       = "0.1.0"
author        = "Status Research & Development GmbH"
description   = "Nim bindings for the zxcvbn-c password strenght estimator"
license       = "Apache License 2.0"
skipDirs      = @["tests"]

requires "nim >= 1.0.0",
         "testutils"

task test, "Run all tests":
  exec "nim c -r --threads:off tests/test_all"
  exec "nim c -r --threads:on tests/test_all"


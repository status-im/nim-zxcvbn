mode = ScriptMode.Verbose

packageName   = "zxcvbn"
version       = "0.1.0"
author        = "Status Research & Development GmbH"
description   = "Nim bindings for the zxcvbn-c password strength estimator"
license       = "Apache License 2.0"
skipDirs      = @["tests"]

requires "nim >= 1.6.0",
         "testutils"

let nimc = getEnv("NIMC", "nim") # Which nim compiler to use
let lang = getEnv("NIMLANG", "c") # Which backend (c/cpp/js)
let flags = getEnv("NIMFLAGS", "") # Extra flags for the compiler
let verbose = getEnv("V", "") notin ["", "0"]
let platform = getEnv("PLATFORM", "")

from std/os import quoteShell

let cfg =
  " --styleCheck:usages --styleCheck:error" &
  (if verbose: "" else: " --verbosity:0") &
  " --skipParentCfg --skipUserCfg --outdir:build -f " &
  quoteShell("--nimcache:build/nimcache/$projectName")

proc build(args, path: string) =
  exec nimc & " " & lang & " " & cfg & " " & flags & " " & args & " " & path

proc run(args, path: string) =
  build args & " -r", path

task test, "Run all tests":
  for threads in ["--threads:off", "--threads:on"]:
    run threads & " --mm:refc", "tests/test_all"
    if (NimMajor, NimMinor) > (1, 6):
      run threads & " --mm:orc", "tests/test_all"

task test_asan, "Run all tests with ASAN":
  if platform != "x86":
    try:
      exec "echo '#if __clang_major__ < 20\n#error\n#endif' | clang -E - >/dev/null"
    except OSError:
      return

    # https://clang.llvm.org/docs/AddressSanitizer.html
    putEnv("ASAN_OPTIONS", "detect_leaks=0:detect_stack_use_after_return=1")
    # https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
    putEnv("UBSAN_OPTIONS", "print_stacktrace=1")
    let asanArgs =
      " --mm:orc -d:useMalloc --cc:clang --debugger:native" &
      " --passC:-fsanitize=address,undefined" &
      " --passL:-fsanitize=address,undefined" &
      " --passC:-fno-sanitize-recover=undefined" &
      " --passC:-fno-sanitize-merge" &
      " --passC:-fno-omit-frame-pointer"
    for threads in ["--threads:off", "--threads:on"]:
      run threads & asanArgs, "tests/test_all"

let
  fuzzSeconds = getEnv("FUZZ_SECONDS", "100")
  fuzzTime =
    if fuzzSeconds == "": " "
    else: " --duration=" & fuzzSeconds & " "

task fuzz, "Run fuzzing tests":
  for fuzzer in ["libFuzzer", "honggfuzz", "afl"]:
    when defined(macosx):
      if fuzzer == "honggfuzz":
        continue

    exec "ntu fuzz --fuzzer=" & fuzzer & fuzzTime & "tests/fuzzing_test"

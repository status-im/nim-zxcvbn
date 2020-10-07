import
  ../zxcvbn

let
  a = passwordEntropy "a"
  cat = passwordEntropy "cat"
  qwerty = passwordEntropy "qwerty"
  abracadabra = passwordEntropy "abracadabra"
  remixedQwerty = passwordEntropy "qwER43@!"
  remixedLongWord = passwordEntropy "Tr0ub4dour&3"
  fourWords = passwordEntropy "correcthorsebatterystaple"
  longRepeatingSequence = passwordEntropy "1111111111111111111111111111111"
  strongPassword = passwordEntropy "ds10s81*&NQLPAfg9*21Ke}|w(*&121=_(11e2"

doAssert strongPassword > fourWords
doAssert fourWords > remixedLongWord
doAssert remixedLongWord > remixedQwerty
doAssert remixedQwerty > abracadabra
doAssert remixedQwerty > qwerty
doAssert remixedQwerty > cat
doAssert remixedQwerty > a
doAssert remixedQwerty > longRepeatingSequence

echo "SUCCESS"

import
  ../zxcvbn

proc passwordEntropy(x: string): float =
  result = zxcvbn.passwordEntropy(x)
  echo x, " = ", result

# ASCII passwords:
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

# UTF-8 Passwords:
let
  bulgarianPassword = passwordEntropy("парола")
  bulgarianRepeatingSeq = passwordEntropy("яяяяяя")
  japanesePassword = passwordEntropy("パスワード")
  japaneseRepeatingSeq = passwordEntropy("パパパパパ")
  chinesePassword = passwordEntropy("密碼")
  chineseFourWords = passwordEntropy("正確的馬電池釘書釘")

doAssert bulgarianPassword > bulgarianRepeatingSeq
doAssert japanesePassword > japaneseRepeatingSeq
doAssert chineseFourWords > chinesePassword

echo "SUCCESS"


import
  testutils/fuzzing,
  ../zxcvbn

proc toString(data: openarray[byte]): string =
  result = newString(data.len)
  if data.len > 0:
    copyMem(addr result[0], unsafeAddr data[0], data.len)

test:
  let entropy = passwordEntropy(toString payload)


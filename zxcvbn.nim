{.compile: "zxcvbn/C/zxcvbn.c".}

when not defined(msvc):
  {.passl: "-lm".}

type
  MatchKind = enum
    NON_MATCH,          # 0
    BRUTE_MATCH,        # 1
    DICTIONARY_MATCH,   # 2
    DICT_LEET_MATCH,    # 3
    USER_MATCH,         # 4
    USER_LEET_MATCH,    # 5
    REPEATS_MATCH,      # 6
    SEQUENCE_MATCH,     # 7
    SPATIAL_MATCH,      # 8
    DATE_MATCH,         # 9
    YEAR_MATCH,         # 10
    MULTIPLE_MATCH = 32 # Added to above to indicate matching part has been repeated

  CMatchInfo = object
    begin*: int           # Char position of begining of match
    length*: int          # Number of chars in the match
    entropy*: float       # The entropy of the match
    multitEntropy*: float # Entropy with additional allowance for multipart password
    kind*: MatchKind      # Type of match (Spatial/Dictionary/Order/Repeat) */
    next*: ptr CMatchInfo

  CMatchInfoPtr = ptr CMatchInfo

proc ZxcvbnMatch(passwd: cstring, userDict: ptr UncheckedArray[cstring], info: ptr CMatchInfoPtr): float {.importc.}
  ## The main password matching function. May be called multiple times.
  ## The parameters are:
  ## passwd      The password to be tested. Null terminated string.
  ## userDict    User supplied dictionary words to be considered particulary bad. Passed
  ##               as a pointer to array of string pointers, with null last entry (like
  ##               the argv parameter to main()). May be null or point to empty array when
  ##               there are no user dictionary words.
  ##  info        The address of a pointer variable to receive information on the parts
  ##               of the password. This parameter can be null if no information is wanted.
  ##               The data should be freed by calling ZxcvbnFreeInfo().
  ## 
  ## Returns the entropy of the password (in bits).

proc ZxcvbnFreeInfo(info: CMatchInfoPtr) {.importc.}

proc passwordEntropy*(password: string): float =
  ## Returns the entropy of the password (in bits).
  ZxcvbnMatch(password, nil, nil)


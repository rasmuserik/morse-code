# {{{1 Notes
# {{{2 How exercises are choosen
#
# Start out practising one letter, then two letters, then three, etc. The order of the letters learned are given by their frequency in the dictionary of the language we are practicing.
#
# We want to practise whole words at a time, so we choose random words from a dictionary, such that each word only contains letters we already know, and words containing recently learned letters are more likely.
#
# {{{2 mindmap of application
#
# - learning / practise
#   - write words / sequence of characters
#     - go through dictionary, decide character learning order based on what would yield most real words
#     - make sure words has high probably of training worst character
#   - if wrong, show code, if still wrong play code
#   - change the number of distinct characters based on how whether correct or wrong answer
#   - show processed input
#   - save statistics
#   - gameification - badges, performance etc.
#     - row of n correct answers
#     - number of distinct characters working with
#     - wpm score (gotten all characters)
# - statistics
#   - be able to see performance over time
#   - statistics per character: speed + correctness
#   - speed graph
#   - number-of-characters / correctness graph
# - note-taking
# - read practise
# - settings: choice of language
#
# {{{1 Boilerplate
# predicates that can be optimised away by uglifyjs
if typeof isNodeJs == "undefined" or typeof runTest == "undefined" then do ->
  root = if typeof global == "undefined" then window else global
  root.isNodeJs = (typeof window == "undefined") if typeof isNodeJs == "undefined"
  root.isPhoneGap = typeof document.ondeviceready != "undefined" if typeof isPhoneGap == "undefined"
  root.runTest = true if typeof runTest == "undefined"
# use - require/window.global with non-require name to avoid being processed in firefox plugins
use = if isNodeJs then ((module) -> require module) else ((module) -> window[module]) 
# execute main
onReady = (fn) ->
  if isNodeJs
    process.nextTick fn
  else
    if document.readystate != "complete" then fn() else setTimeout (-> onReady fn), 17 
# {{{1 utility
uu.pick = (arr) -> arr[Math.random() * arr.length | 0]
# {{{1 alphabet
alphabet:
  a: ".-"
  b: "-..."
  c: "-.-."
  d: "-.."
  e: "."
  f: "..-."
  g: "--."
  h: "...."
  j: "--."
  k: "-.-"
  l: ".-.."
  m: "--"
  n: "-."
  o: "---"
  p: ".--."
  q: "--.-"
  r: ".-."
  s: "..."
  t: "-"
  u: "..-"
  v: "...-"
  w: ".--"
  x: "-..-"
  y: "-.--"
  z: "--.."
  "0": "-----"
  "1": ".----"
  "2": "..---"
  "3": "...--"
  "4": "....-"
  "5": "....."
  "6": "-...."
  "7": "--..."
  "8": "---.."
  "9": "----."
  ".": ".-.-.-"
  ",": "--..--"
  "?": "..--.."
  "'": ".----."
  "!": ".-.---"
  "/": "-..-."
  "(": "-.--."
  ")": "-.--.-"
  "&": ".-..."
  ":": "---..."
  ";": "-.-.-."
  "=": "-...-"
  "+": ".-.-."
  "-": "-....-"
  "_": "..--.-"
  '"': ".-..-."
  "$": "...-..-"
  "@": ".--.-."
  "æäą": ".-.-"
  "åà": ".--.-"
  "çĉć": "-.-.."
  "šĥ": "----"
  "ð": "..--."
  "ś": "...-..."
  "èł": ".-..-"
  "éđę": "..-.."
  "ĝ": "--.-."
  "ĵ": ".---."
  "ź": "--..-."
  "ñń": "--.--"
  "øöó": "---."
  "ŝ": "...-."
  "þ": ".--.."
  "üŭ": "..--"
  "ż": "--..-"

#{{{1 dictionaries
dicts = {}
randDict = (symbs) ->
  for i in [0..999]
    word = ""
    for j in [0..Math.random() * 4 + 1]
      word += uu.pick symbs
    word

genDicts = (cb) ->

  readDict = (lang, fn) ->
    uu.ajax "#{lang}words.txt", undefined, (err, result) ->
      throw err if err
      fn result.slice(0,-1).toLocaleLowerCase().split("\n").map (a)->a.trim()

  handleCreatedWords = ->
    for lang, dict of dicts
      freq = {}
      for word in dict.words
        for letter in word
          freq[letter] ?= 0
          ++freq[letter]
      letters = Object.keys freq
      letters.sort (a,b) -> freq[b] - freq[a]
      dict.letters = letters
    cb? dicts


  genCallback = uu.whenDone handleCreatedWords
  for lang in ["en", "da"]
    dicts[lang] = {}
    readDict lang, ((lang, cb) -> (words) ->
      dicts[lang].words = words
      cb()
    )(lang, genCallback())

  dicts.num = {words: randDict "0123456789"}
  dicts.symb = {words: randDict ".,?'!/()&:;=+-_\"$@"}

  
#{{{1 Choose exercise words

exercise = (lang, n) ->
  exerciseList = (lang, n, letterNo) ->
    letters = dicts[lang].letters.slice(0, n)
    letterDict = {}
    for letter in letters
      letterDict[letter] = true
    reqLetter = letters[letterNo]
    dicts[lang].words.filter (word) ->
      hasReqLetter = false
      for letter in word
        return false if !letterDict[letter]
        hasReqLetter = true if letter == reqLetter
      return hasReqLetter
  letterNo = n
  letterNo = (n - Math.pow(Math.random(), 4) * n) | 0 while letterNo >= Math.min(n, dicts[lang].letters.length)
  uu.pick exerciseList lang, n, letterNo

#{{{1
onReady ->
  genDicts (dicts) ->
    console.log dicts
    lang = "da"
    for i in [2..30]
      console.log dicts[lang].letters[i-1], (exercise lang, i for j in [1..20]).join " "

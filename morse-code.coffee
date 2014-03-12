# {{{1 Notes
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
#{{{1
onReady ->
  console.log "HERE"


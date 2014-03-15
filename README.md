# Morse code learning and note taking 0.0.0

utility for learning to take notes on a smartphone without looking at the screen

# Notes
## How exercises are choosen

Start out practising one letter, then two letters, then three, etc. The order of the letters learned are given by their frequency in the dictionary of the language we are practicing.

We want to practise whole words at a time, so we choose random words from a dictionary, such that each word only contains letters we already know, and words containing recently learned letters are more likely.

## Roadmap

### version 0.1.0

- exercise english morse code
- write performance to log

### mindmap of end application

- learning / practise
  - write words / sequence of characters
    - go through dictionary, decide character learning order based on what would yield most real words
    - make sure words has high probably of training worst character
  - if wrong, show code, if still wrong play code
  - change the number of distinct characters based on how whether correct or wrong answer
  - show processed input
  - save statistics
  - gameification - badges, performance etc.
    - row of n correct answers
    - number of distinct characters working with
    - wpm score (gotten all characters)
- statistics
  - be able to see performance over time
  - statistics per character: speed + correctness
  - speed graph
  - number-of-characters / correctness graph
- note-taking
- read practise
- settings: choice of language

# Boilerplate
predicates that can be optimised away by uglifyjs

    if typeof isNodeJs == "undefined" or typeof runTest == "undefined" then do ->
      root = if typeof global == "undefined" then window else global
      root.isNodeJs = (typeof window == "undefined") if typeof isNodeJs == "undefined"
      root.isPhoneGap = typeof document.ondeviceready != "undefined" if typeof isPhoneGap == "undefined"
      root.runTest = true if typeof runTest == "undefined"

use - require/window.global with non-require name to avoid being processed in firefox plugins

    use = if isNodeJs then ((module) -> require module) else ((module) -> window[module]) 

execute main

    onReady = (fn) ->
      if isNodeJs
        process.nextTick fn
      else
        if document.readystate != "complete" then fn() else setTimeout (-> onReady fn), 17 

# utility TODO: merge into uutil
## General

    uu.pick = (arr) -> arr[Math.random() * arr.length | 0]
    uu.domListen = (elem, event, fn) -> #{{{3
      if elem.addEventListener
        elem.addEventListener event, fn, false
      else
        elem.attachEvent "on#{event}", fn
    uu.onComplete = (fn) -> #{{{3
      if document.readystate != "complete" 
        fn()
      else
        setTimeout (-> uu.onComplete fn), 17 

## Logging

We want to send logging and statistics to server, 
but not drain battery nor exhaust the network,
so the log is saved to memory, and then only send across the network 
when more than `logBeforeSync` entries has been collected, 
or the user leaves the page. It is also throttled, 
so logging data are sent no more than once every `syncDelay` milliseconds.

On legacy browsers we cannot send the log when the user leave the page,
so there we just send update every `syncDelay` milliseconds.


    ajaxLegacy = false #TODO: remove this line 
    do ->
      logId = Math.random()
      logUrl = "//ssl.solsort.com/api/log"
      logData = []
      logSyncing = false
      logsBeforeSync = 200
      syncDelay = 400
      uu.syncLog = -> #{{{3
        if !logSyncing
          try
            logContent = JSON.stringify logData
          catch e
            logContent = "Error stringifying log"
          logSyncing = logData
          logData = []
          uu.ajax logUrl, logContent, (err, result) ->
            setTimeout (-> logSyncing = false), syncDelay
            if err
              log "logsync error", err
              logData = logSyncing.concat(logData)
            else
              logData.push [+(new Date()), "log sync'ed", logId, logData.length]
              uu.syncLog() if (ajaxLegacy || runTest) && logData.length > 1
    
      uu.log = (args...) -> #{{{3
        logData.push [+(new Date()), args...]
        uu.nextTick uu.syncLog if logData.length > logsBeforeSync || ajaxLegacy || runTest
        return args
    
      uu.onComplete -> #{{{3
        uu.domListen window, "error", (err) ->
          uu.log "window.onerror ", String(err)
        uu.domListen window, "beforeunload", ->
          uu.log "window.beforeunload"
          try
            uu.ajax logUrl, JSON.stringify logData # blocking POST request
          catch e
            undefined
          undefined
      uu.log "starting", logId, window.performance
      uu.log "userAgent", navigator.userAgent
    
    

# Data

    exercise = undefined
    genDicts = undefined
    alphabet = undefined

## morse alphabet

    alphabet =
      a: ".-"
      b: "-..."
      c: "-.-."
      d: "-.."
      e: "."
      f: "..-."
      g: "--."
      i: ".."
      h: "...."
      j: ".---"
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
      "æ": ".-.-"
      "ä": ".-.-"
      "ą": ".-.-"
      "à": ".--.-"
      "à": ".--.-"
      "ç": "-.-.."
      "ĉ": "-.-.."
      "ć": "-.-.."
      "š": "----"
      "ĥ": "----"
      "ð": "..--."
      "ś": "...-..."
      "ł": ".-..-"
      "è": ".-..-"
      "é": "..-.."
      "đ": "..-.."
      "ę": "..-.."
      "ĝ": "--.-."
      "ĵ": ".---."
      "ź": "--..-."
      "ñ": "--.--"
      "ń": "--.--"
      "ø": "---."
      "ö": "---."
      "ó": "---."
      "ŝ": "...-."
      "þ": ".--.."
      "ü": "..--"
      "ŭ": "..--"
      "ż": "--..-"
    

## Exercises / languages and choices of words for practise

    do ->
      dicts = {}
      randDict = (symbs) -> #{{{3
        for i in [0..999]
          word = ""
          for j in [0..Math.random() * 4 + 1]
            word += uu.pick symbs
          word
      
      genDicts = (cb) -> #{{{3
      
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
      
      exercise = (lang, n) -> #{{{3
        uu.log "morse exercise", lang, n
        n = n|0
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
      

# morse parse

timings:
- dot 1
- element space 1
- dash 3
- letter space 3
- word space 7

wpm = 2.4/dots-per-second


click<100ms: dot
click>100ms: dash
pause<150ms: element space
150ms<pause<400ms letter-space
pause>400ms: space

    
    ondot = ondash = onletter = onspace = undefined
    uu.onComplete ->
      dashTime = 200
      letterTime = 330
      spaceTime = 800
    
      time = Date.now()
    
      code = ""
      ondot = -> code += "."
      ondash = -> code += "-"
      onletter = -> code += " "
      onspace = ->
        code = ""
    
    
      touchStart = (e) ->
        e.preventDefault()
        now = time = Date.now()
        uu.log "morsestart", now, dashTime
        setTimeout (-> if time == now then ondash() else ondot()), dashTime
        false
    
      touchEnd = (e) ->
        e.preventDefault()
        now = time = Date.now()
        uu.log "morseend", now, letterTime, spaceTime
        setTimeout (-> onletter() if time == now), letterTime
        setTimeout (-> onspace() if time == now), spaceTime
        false
    
    
      uu.domListen document, "keydown", touchStart
      uu.domListen document, "keyup", touchEnd
      if typeof document.ontouchstart != "undefined"
        uu.domListen document, "touchstart", touchStart
        uu.domListen document, "touchend", touchEnd
      else
        uu.domListen document, "mousedown", touchStart
        uu.domListen document, "mouseup", touchEnd
    

##
## touch timing

    timings = []
    touching = false
    prev = undefined
    registerTouch = ->
      prev = Date.now()
      state = (doTouch) ->
        return if touching == doTouch
        touching = doTouch
        now = Date.now()
        timings.push now - prev
        console.log touching, now - prev
        prev = now
    
      uu.domListen document, "touchstart", -> state true
      uu.domListen document, "keydown", -> state true
      uu.domListen document, "mousedown", -> state true
      uu.domListen document, "touchend", -> state false
      uu.domListen document, "keyup", -> state false
      uu.domListen document, "mouseup", -> state false
    

## interprete as morse characters

    
    parseMorse = ->
      result = ""
      min = Math.max 30, Math.min.apply null, timings
      for i in [1..timings.length] by 2
        result += if timings[i] > min * 2.5 then "-" else "."
        result += " " if timings[i+1] > min * 3.5
      document.getElementById("morsecodes").innerHTML = result.split(" ").join(" &nbsp; ")
      return result
    
    uu.onComplete ->
      setInterval parseMorse, 1000
    

## visualise morse code

    renderMorse = ->
      ctx = document.getElementById("renderMorse").getContext("2d")
      w = ctx.canvas.width
      renderMorse = ->
        i = timings.length - 1
        state = touching
        ctx.fillStyle = "#fff"
        ctx.fillRect 0, 0, w, 1
        ctx.fillStyle = "#000"
    
        x = w
        while x >= 0 and i >=0
          len = timings[i] * .04
          x -= len
          ctx.fillRect x, 0, len, 1 if !state
          state = !state
          --i
        setTimeout renderMorse, 100
      renderMorse()

##
# quiz

    level = 1
    lang = "en"
    quiz = ->
      word = exercise lang, level
      uu.log "morsequiz", level, word
      tries = 0
      unit = Math.min(window.innerWidth, window.innerHeight) / 10
      document.body.innerHTML = jsonml2html.toString ["div"
          style:
            fontFamily: "sans-serif"
            textAlign: "center"
            fontSize: unit
        ["div",
            style:
              fontSize: unit*.8
              margin: unit*.5
          "level: ", level]
        ["div",
            style:
              fontSize: unit*2
          word]
        ["div#entry",
            style:
              fontSize: unit*1.5
          ""]
        ["div#entryLetters", ""]
      ]
      tries = 0
      entry = (document.getElementById "entry")
      entryLetters = (document.getElementById "entryLetters")
      resetEntry = false
      addEntry = (str) ->
        if resetEntry
          entry.innerHTML = ""
          resetEntry = false
        entry.innerHTML += str
      ondot = -> addEntry "."
      ondash = -> addEntry "-"
      onletter = ->
        letters = String(entry.innerHTML).split(" ").map (morse) ->
          for symb, code of alphabet
            return symb if morse == code
          return morse
        entryLetters.innerHTML = letters.join ""
        addEntry " "
      onspace = ->
        ++tries
        if String(entryLetters.innerHTML) == word
          level += Math.max(2 - tries, -1)
          level = Math.max(level, 1)
          return uu.nextTick quiz
        entryLetters.innerHTML = jsonml2html.toString ["div"
            style:
              color: "#800"
              fontSize: unit * .5
          ["div", entry.innerHTML]
          ["div", entryLetters.innerHTML]]
        entry.innerHTML = jsonml2html.toString ["div"
            style:
              color: "#040"
          word.split("").map((a) -> alphabet[a]).join " "]
        resetEntry = true
    
    

# main

    uu.onComplete ->
      document.body.innerHTML = jsonml2html.toString ["div"
        ["canvas#renderMorse"
            width: 800
            height: 1
            style: {width: "80%", height: 20}
          ""]
        ["div#morsecodes", ""]
      ]

renderMorse()
registerTouch()

      genDicts (dicts) -> quiz()
    

----

README.md autogenerated from `morse-code.coffee` ![solsort](https://ssl.solsort.com/_reputil_rasmuserik_morse-code.png)

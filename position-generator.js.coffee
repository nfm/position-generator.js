# https://github.com/nfm/position-generator.js
#
# Based on https://github.com/ask11/backbone-position by Aleksey Kulikov
#
# (c) 2013 - Nicholas Firth-McCoy
# (c) 2012 - Aleksey Kulikov
#
# May be freely distributed according to MIT license.

PositionGenerator =
  # Generate a unique position between `prev` and `next` values
  # Reduce `next` value and raise result until it is higher than `prev` value
  #
  # PositionGenerator.between('1', '2') # => '11'
  # PositionGenerator.between('0', '101') # => '1001'
  between: (prev, next) ->
    prev = ""  unless prev
    throw new Error("Prev value (#{prev}) greater than next value (#{next})") if prev >= next
    string = (if prev.length > 0 then prev else "1")
    string = @reduce(next) if next
    string = @raise(string) while string <= prev
    string

  # Increase a string's last character based on ASCII table
  #
  # PositionGenerator.raise('123') # => '124'
  # PositionGenerator.raise('9') # => ':'
  raise: (string) ->
    @handleLastChar string, (lastCode) ->
      String.fromCharCode lastCode + 1

  # Decrease a string's last character and append "1"
  # Returns "1" for blank string
  #
  # PositionGenerator.reduce('1') # => '01'
  # PositionGenerator.reduce('111') # => '1101'
  reduce: (string) ->
    @handleLastChar string, (lastCode) ->
      reducedChar = (if lastCode then String.fromCharCode(lastCode - 1) else "")
      reducedChar + "1"

  # Helper to change the last character of a string
  # Called by raise() and reduce()
  handleLastChar: (string, handler) ->
    shortLength = string.length - 1
    lastCode = string.charCodeAt(shortLength)
    string.slice(0, shortLength) + handler(lastCode)

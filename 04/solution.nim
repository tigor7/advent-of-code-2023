import std/[re, strutils, sequtils, math, tables]

type
  Card = object
    id: int
    winningNums: seq[string]
    cardNums: seq[string]

proc readCardsFromFile(filename: string): seq[Card] =
  for line in lines filename:
    let
      parsed = line.split(":")
      id = parseInt(parsed[0].splitWhitespace[1])
      nums = parsed[1].split("|")
      winningNums = findAll(nums[0], re"\d+")
      cardNums = findAll(nums[1], re"\d+")
    result.add(Card(id: id, winningNums: winningNums, cardNums: cardNums))

proc getMatches(card: Card): int =
  return filter(card.cardNums, proc(x: string): bool = x in
      card.winningNums).len

proc part1(filename: string): int =
  let cards = readCardsFromFile(filename)
  for card in cards:
    let matches = getMatches(card)
    if matches > 0:
      result += 2^(matches - 1)

proc part2(filename: string): int =
  var
    cards = readCardsFromFile(filename)
    copies = initTable[int, int]()

  for card in cards:
    var
      matches = getMatches(card)
      cardCopies = 0

    if card.id in copies:
      cardCopies = copies[card.id]
    for i in 1..matches:
      if card.id + i notin copies:
        copies[card.id + i] = 1 + cardCopies
      else:
        copies[card.id + i] += 1 + cardCopies
    result += 1 + cardCopies


when isMainModule:
  let
    part1TestResult = part1("test.txt")
    part2TestResult = part2("test.txt")
    part1Result = part1("input.txt")
    part2Result = part2("input.txt")

  assert part1TestResult == 13
  assert part2TestResult == 30

  assert part1Result == 26218
  assert part2Result == 9997537

import ../utils
import std/[strutils]

type
  Kind = enum
    greater, lesser, none

  Stament = object
    first: string
    second: string
    kind: Kind
    next: string


  Workflow = object
    code: string
    stmts: seq[Stament]

  Rating = object
    x: int
    m: int
    a: int
    s: int

proc get(r: Rating, val: string): int =
  case val:
  of "x":
    result = r.x
  of "m":
    result = r.m
  of "a":
    result = r.a
  of "s":
    result = r.s
  else:
    result = parseInt(val)

proc getWorkflow(workflows: seq[Workflow], code: string): Workflow =
  for w in workflows:
    if w.code == code:
      return w

proc readStmts(raw: string): seq[Stament] =
  let sslip = raw.split(",")
  for s in sslip:
    if '<' in s:
      let
        p = s.split(":")
        next = p[1]
        d = p[0].split("<")
        first = d[0]
        second = d[1]
      result.add Stament(kind: Kind.lesser, first: first, second: second, next: next)
    elif '>' in s:
      let
        p = s.split(":")
        next = p[1]
        d = p[0].split(">")
        first = d[0]
        second = d[1]
      result.add Stament(kind: Kind.greater, first: first, second: second, next: next)
    else:
      result.add Stament(kind: Kind.none, next: s)

proc readRating(raw: string): Rating =
  let s = raw.split(",")
  result.x = parseInt(s[0].split("=")[1])
  result.m = parseInt(s[1].split("=")[1])
  result.a = parseInt(s[2].split("=")[1])
  result.s = parseInt(s[3].split("=")[1])

proc readInput(filename: string, workflows: var seq[Workflow], ratings: var seq[Rating]) =
  let f = open(filename)

  while not endOfFile(f):
    let line = f.readLine
    if line == "":
      break
    let
      p = line.split("{")
      code = p[0]
      stmts = readStmts(p[1][0..^2])
    workflows.add Workflow(code: code, stmts: stmts)

  while not endOfFile(f):
    ratings.add readRating(f.readLine[1..^2])

proc part1(filename: string): int =
  var
    workflows: seq[Workflow]
    ratings: seq[Rating]
  readInput(filename, workflows, ratings)

  for rating in ratings:
    var last = "in"
    while true:
      if last == "A":
        result += rating.x + rating.m + rating.a + rating.s
        break
      elif last == "R":
        break
      let curr = getWorkflow(workflows, last)
      for s in curr.stmts:
        if s.kind == Kind.lesser and rating.get(s.first) < rating.get(s.second):
          last = s.next
          break
        elif s.kind == Kind.greater and rating.get(s.first) > rating.get(s.second):
          last = s.next
          break
        last = s.next

proc part2(filename: string): int =
  discard

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 401674
  echo ""
  benchmark "Part 2":
    let part2Result = part2("test.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 0

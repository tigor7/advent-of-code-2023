import ../utils
import std/strutils

type
  Point = (int, int)
  MapInfo = object
    points: seq[Point]
    size: int

proc readPoints(filename: string): MapInfo =
  var last = (0, 0)
  for line in lines filename:
    let
      n = parseInt(line.split()[1])
    result.size += n
    case line[0]:
    of 'R':
      let added = last + (0, n)
      result.points.add added
      last = added
    of 'L':
      let added = last - (0, n)
      result.points.add added
      last = added
    of 'U':
      let added = last - (n, 0)
      result.points.add added
      last = added
    of 'D':
      let added = last + (n, 0)
      result.points.add added
      last = added
    else:
      discard

proc readPoints2(filename: string): MapInfo =
  var last = (0, 0)
  for line in lines filename:
    let
      n = parseHexInt(line.split()[2][2..^3])
    result.size += n
    case line[^2]:
    of '0':
      let added = last + (0, n)
      result.points.add added
      last = added
    of '2':
      let added = last - (0, n)
      result.points.add added
      last = added
    of '3':
      let added = last - (n, 0)
      result.points.add added
      last = added
    of '1':
      let added = last + (n, 0)
      result.points.add added
      last = added
    else:
      discard

proc part1(filename: string): int =
  let
    mapInfo = readPoints(filename)
    size = mapInfo.size
    points = mapInfo.points
  var det = 0
  for i in 0 ..< points.len:
    var
      c1 = i
      c2 = i + 1
    if c1 == points.len - 1:
      c2 = 0
    det += points[c1][0] * points[c2][1] - points[c2][0] * points[c1][1]
  let
    shoelace = abs(det) div 2
    inner = shoelace - (size div 2) + 1
  result = size + inner

proc part2(filename: string): int =
  let
    mapInfo = readPoints2(filename)
    size = mapInfo.size
    points = mapInfo.points
  var det = 0
  for i in 0 ..< points.len:
    var
      c1 = i
      c2 = i + 1
    if c1 == points.len - 1:
      c2 = 0
    det += points[c1][0] * points[c2][1] - points[c2][0] * points[c1][1]
  let
    shoelace = abs(det) div 2
    inner = shoelace - (size div 2) + 1
  result = size + inner

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 40714
  echo ""
  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 129849166997110

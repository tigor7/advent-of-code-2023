import ../utils
import std/[re, strutils]

type
  Race = object
    distance: int
    time: int

proc readRacesFromFile(filename: string): seq[Race] =
  let
    pattern = re"\d+"
    f = open(filename)

  defer: f.close()
  let
    times = findAll(readLine(f), pattern)
    distances = findAll(readLine(f), pattern)
  for i in 0..<times.len:
    result.add(Race(distance: parseInt(distances[i]), time: parseInt(times[i])))

proc part1(filename: string): int =
  result = 1
  let races = readRacesFromFile(filename)
  for race in races:
    var winning = 0
    for i in 1..<race.time:
      if (i * (race.time - i)) > race.distance:
        winning += 1
    result *= winning




proc part2(filename: string): int =
  discard


when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 140220

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 72263011

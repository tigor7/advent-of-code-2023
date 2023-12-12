import ../utils
import std/[re, math]

type
  Node = object
    val: string
    left: string
    right: string

proc readNodes(filename: string, nodes: var seq[Node], inst: var string) =
  let f = open(filename)
  inst = readLine(f)
  discard readLine(f)
  while not endOfFile(f):
    let line = findAll(readLine(f), re"\w+")
    nodes.add(Node(val: line[0], left: line[1], right: line[2]))

proc getNode(nodes: seq[Node], val: string): Node =
  for node in nodes:
    if node.val == val:
      return node

proc getStartNodes(nodes: seq[Node]): seq[Node] =
  for node in nodes:
    if node.val[^1] == 'A':
      result.add(node)

proc part1(filename: string): int =
  var
    nodes: seq[Node]
    inst: string
  readNodes(filename, nodes, inst)
  var curr = nodes.getNode("AAA")
  var i = 0
  while true:
    if curr.val == "ZZZ":
      break
    let a = inst[i mod inst.len]
    if a == 'L':
      curr = nodes.getNode(curr.left)
    elif a == 'R':
      curr = nodes.getNode(curr.right)
    inc i
  return i


proc part2(filename: string): int =
  var
    nodes: seq[Node]
    inst: string
  readNodes(filename, nodes, inst)
  var curr = getStartNodes(nodes)
  var cycles: seq[int]
  for i in 0..<curr.len:
    var
      c = 0
      j = 0
    while true:
      if curr[i].val[^1] == 'Z':
        break
      let a = inst[j mod inst.len]
      if a == 'L':
        curr[i] = nodes.getNode(curr[i].left)
      elif a == 'R':
        curr[i] = nodes.getNode(curr[i].right)
      inc c
      inc j
    cycles.add(c)

  return lcm(cycles)

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 19783

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 9177460370549

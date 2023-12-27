import std/[monotimes, times, macros]

proc `+`*(a, b: (int, int)): (int, int) =
  return (a[0] + b[0], a[1] + b[1])

proc `-`*(a, b: (int, int)): (int, int) =
  return (a[0] - b[0], a[1] - b[1])

type
  Cell*[T] = object
    val*: T
    dis*: int
  Matrix*[T] = seq[seq[Cell[T]]]

proc get*[T](m: Matrix[T], i, j: int): T =
  result = m[i][j].val

proc get*[T](m: Matrix[T], n: (int, int)): T =
  result = m.get(n[0], n[1])

proc display*(m: Matrix) =
  for i in 0..<m.len:
    for j in 0..<m[i].len:
      stdout.write m.get(i, j), " "
    echo ""

proc checkBounds*(m: Matrix, i, j: int): bool =
  result = i >= 0 and i < m.len and j >= 0 and j < m[i].len

proc `in`*(c: (int, int), m: Matrix): bool =
  result = checkBounds(m, c[0], c[1])

template benchmark*(benchmarkName: string, code: untyped) =
  block:
    let t0 = getMonoTime()
    code
    let elapsed = getMonoTime() - t0
    var formated = $elapsed.inMicroseconds & " us"
    if elapsed.inMicroseconds > 1000:
      formated = $elapsed.inMilliseconds & " ms"
    echo "CPU Time [", benchmarkName, "] ", formated


proc displayMatrix*[T](matrix: seq[seq[T]]) =
  for i in 0..<matrix.len:
    for j in 0..<matrix[i].len:
      stdout.write matrix[i][j], " "
    echo ""

proc inBounds*[T](matrix: seq[seq[T]], i, j: int): bool =
  return i >= 0 and i < matrix.len and j >= 0 and j < matrix[i].len

macro debug*(n: varargs[typed]): untyped =
  result = newNimNode(nnkStmtList, n)
  for i in 0..n.len-1:
    if n[i].kind == nnkStrLit:
      # pure string literals are written directly
      result.add(newCall("write", newIdentNode("stdout"), n[i]))
    else:
      # other expressions are written in <expression>: <value> syntax
      result.add(newCall("write", newIdentNode("stdout"), toStrLit(n[i])))
      result.add(newCall("write", newIdentNode("stdout"), newStrLitNode(": ")))
      result.add(newCall("write", newIdentNode("stdout"), n[i]))
    if i != n.len-1:
      # separate by ", "
      result.add(newCall("write", newIdentNode("stdout"), newStrLitNode(", ")))
    else:
      # add newline
      result.add(newCall("writeLine", newIdentNode("stdout"), newStrLitNode("")))

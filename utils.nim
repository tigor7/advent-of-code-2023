import std/[monotimes, times]

template benchmark*(benchmarkName: string, code: untyped) =
  block:
    let t0 = getMonoTime()
    code
    let elapsed = getMonoTime() - t0
    echo "CPU Time [", benchmarkName, "] ", elapsed.inMilliseconds, "ms"

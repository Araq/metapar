

import threadpool, math

{.experimental.}

proc linearFind(a: openArray[int]; x: int): int =
  for i, y in a:
    if y == x: return i
  result = -1

proc parFind(a: seq[int]; x: int): int =
  var results: array[4, int]
  parallel:
    let chunk = a.len div 4
    results[0] = spawn linearFind(a[0 ..< chunk], x)
    results[1] = spawn linearFind(a[chunk ..< chunk*2], x)
    results[2] = spawn linearFind(a[chunk*2 ..< chunk*3], x)
    results[3] = spawn linearFind(a[chunk*3 ..< a.len], x)
  result = min(results)

let data = toSeq(1..1000)
echo parFind(data, 500)





import macros


proc f(a, b, c: int): int = a+b+c

#curry(proc f(a, b, c: int): int = a+b+c, 10) -->
#      proc newF(b: int, c: int): int = f(10, b, c)

#proc f(a, b: int): int = 10+a+b

macro curry(f: typed; args: varargs[untyped]): untyped =
  let ty = getType(f)
  assert($ty[0] == "proc", "first param is not a function")
  let n_remaining = ty.len - 2 - args.len
  assert n_remaining > 0, "cannot curry all the parameters"
  #echo treerepr ty

  var callExpr = newCall(f)
  args.copyChildrenTo callExpr

  var params: seq[NimNode] = @[]
  # return type
  params.add ty[1]

  for i in 0 .. <n_remaining:
    let param = ident("arg"& $i)
    params.add newIdentDefs(param, ty[i+2+args.len])
    callExpr.add param
  result = newProc(procType = nnkLambda, params = params, body = callExpr)


echo curry(f, 10)(3, 4)

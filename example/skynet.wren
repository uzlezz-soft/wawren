// A million fiber microbenchmark based on: https://github.com/atemerev/skynet.
class Skynet {
  static makeFiber(num, size, div) {
    return Fiber.new(|| {
      if (size == 1) {
        Fiber.yield(num)
      } else {
        let fibers = []
        for (i in 0...div) {
          let subNum = num + i * (size / div)
          fibers.add(makeFiber(subNum, size / div, div))
        }

        let sum = 0
        for task in fibers {
          sum = sum + task.call()
        }
        Fiber.yield(sum)
      }
    })
  }
}

let start = System.clock
let result = Skynet.makeFiber(0, 1000000, 10).call()
let end = System.clock
System.print("Result: ${result} in ${end - start} s")

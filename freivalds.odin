package main

import "core:fmt"
import "core:testing"
import "core:math/rand"

main :: proc() {
  size :: 4 
  A := random_n_by_n(size) 
  B := random_n_by_n(size)

  fmt.println("V: Hey prover, multiply", A, "by", B)

  // Odin is kind enough to support array multiplication for us :)
  C := A * B
  // Uncomment to use dishonest prover
  // C := A * B


  fmt.println("P: claim AB =", C)
  fmt.println("V: Verifying ABx = Cx")

  b_output := freivalds_verify(size, A, B, C)
  fmt.println("output: ", b_output)

}


random_n_by_n :: proc($size : int) -> (mret: [size][size]int) {
  m : [size][size]int
  // my_rand := rand.create(1)

  for i in 0..<size {
    for j in 0..<size {
      m[i][j] = rand.int_max(10)
      
    }
  }

  return m
}

random_vector :: proc($size : int) -> (mret: [size]int) {
  m : [size]int
  my_rand := rand.create(1)

  for i in 0..<size {
      m[i] = rand.int_max(10, &my_rand)
  }

  return m
}


freivalds_verify :: proc($size: int, A: [size][size]int, B: [size][size]int, C: [size][size]int) -> bool {
  x : [size]int = random_vector(size)

  Cx: [size]int
  ABx: [size]int

  for c, i in C {
    result : int
    mul_result := c * x[i]
    for r in mul_result {
      result += r 
    }

    Cx[i] = result

  }

  AB := A * B
  for b, i in AB {
    result : int
    mul_result := b * x[i]
    for r in mul_result {
      result += r 
    }

    ABx[i] = result

  }
  return Cx == ABx
}

@test
test_honest_mat_mul :: proc(t: ^testing.T) {
  size :: 4 
  A := random_n_by_n(size) 
  B := random_n_by_n(size)

  fmt.println("V: Hey prover, multiply", A, "by", B)

  // Odin is kind enough to support array multiplication for us :)
  C := A * B

  fmt.println("P: claim AB =", C)
  fmt.println("V: Verifying ABx = Cx")

  output := freivalds_verify(size, A, B, C)
  fmt.println("output: ", output)
  testing.expect(t, output)

}


@test
test_dishonest_mat_mul :: proc(t: ^testing.T) {
  size :: 4 
  A := random_n_by_n(size) 
  B := random_n_by_n(size)

  fmt.println("V: Hey prover, multiply", A, "by", B)

  // Odin is kind enough to support array multiplication for us :)
  C := random_n_by_n(size) * random_n_by_n(size) 

  fmt.println("P: claim AB =", C)
  fmt.println("V: Verifying ABx = Cx")

  output := freivalds_verify(size, A, B, C)
  fmt.println("output: ", output)
  testing.expect(t, !output)

}

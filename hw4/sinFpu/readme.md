## sinFpu

Write a program that takes two inputs: a natural number `n` and a floating-point or integer `θ`, and calculates the following expression:

\[
f(n,θ) = \sum_{k=1}^{n} \frac{sin(kθ)}{k}
\]

### Input

- The first line contains the natural number `n`.
- The second line contains the integer or floating-point number `θ`, which is in radians.
- \(1 \leq n \leq 10000\)

### Output

The output should be the value of \(f(n,θ)\), accurate to exactly 6 decimal places.

### Example

#### Sample Input 1

```
1
0
```

#### Sample Output 1

```
0.000000
```

#### Sample Input 1

```
10
22.07
```

#### Sample Output 1

```
-0.004344
```

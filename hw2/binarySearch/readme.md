## Binary Search for First Occurrence

You are given a sorted array of length `n` and a number `x`. If the number `x` exists in the array, you should print the index of its first occurrence. If it does not exist, print `NaN`.

For this exercise, you must implement the binary search algorithm recursively and pass the parameters using the stack only.

### Input

- The first line contains the integer `n`, which specifies the length of the array.
- The next `n` lines contain one element of the array each.
- It is guaranteed that these numbers fit within 4 bytes.

### Constraints

- \(0 \leq a_i \leq 2^{31}\)
- The array is guaranteed to be sorted.

### Output

You should print an index or `NaN`.

### Example Input 1

```
5
0
3
3
4
6
3
```

### Output 1

```
1
```

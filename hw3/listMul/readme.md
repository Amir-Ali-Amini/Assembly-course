## List Product Calculation

Write a program that takes `n` lists as input and returns the product of the contents of these lists.

### Input

- First, it takes an integer `n`, which represents the number of lists.
- Then, for `n` times, it takes the length of the list followed by the elements of the list.
- The maximum number of elements in each list is 100.
- Each element and their product should fit within 8 bytes.

### Output

- Print the product of the elements of each list on `n` separate lines.

### Note 1

- Your code should have a function to calculate the product, and the parameters for this function should be passed using the stack.

### Note 2

- Ensure that no extra characters are produced in the output.

### Note 3

- Lists can be empty.

### Example Input

```
3
4
2
3
5
1
2
4
6
3
10
7
5
```

### Output

```
30
24
350
```

We have 3 lists, where the first, second, and third lists have 4, 2, and 3 elements respectively:

- `list1 = [2, 3, 5, 1]`
- `list2 = [4, 6]`
- `list3 = [10, 7, 5]`

The products of the elements in each list are as follows:

- For `list1`:
  \[
  2 \times 3 \times 5 \times 1 = 30
  \]

- For `list2`:
  \[
  4 \times 6 = 24
  \]

- For `list3`:
  \[
  10 \times 7 \times 5 = 350
  \]

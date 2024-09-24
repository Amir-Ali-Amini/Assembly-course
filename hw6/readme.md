## Assembly Program to Count Word Occurrences

Write an assembly program that receives a folder path and a word in string format as input, and counts the occurrences of that word in each `.txt` file within the specified folder. The results should be saved to a file.

### Input

The input consists of two lines:

- The first line contains the folder path.
- The second line contains the word to be searched.

### Output

Your output should be a file named `result.txt` in the folder containing the code. This file should have `n` lines, where each line contains the name of a `.txt` file (sorted alphabetically) and the number of occurrences of the given word in that file.

### Example

#### Sample Input 1

```
path_to_dir
word
```

#### Sample Output 1

```
[contents of result.txt]
file1.txt n1
file2.txt n2
.
.
filem.txt nm
```

# r-base-shortcuts

<a href="https://nanx.me/blog/post/r-base-shortcuts/">
<img src="images/banner.png" alt="r-base-shortcuts"> </a>

A collection of lesser-known but powerful base R idioms and shortcuts
for writing concise and fast base R code, useful for beginner level to
intermediate level R developers.

Please help me improve and extend this list.
See [contributing guide](.github/CONTRIBUTING.md)
and [code of conduct](.github/CODE-OF-CONDUCT.md).

> Why?
>
> From 2012 to 2022, I answered thousands of R questions in the
> online community [Capital of Statistics](https://d.cosx.org/).
> These recipes are observed and digested from the recurring patterns
> I learned from the frequently asked questions with less common answers.

## Contents

- [Object creation](#object-creation)
  - [Create sequences with `seq_len()` and `seq_along()`](#create-sequences-with-seq_len-and-seq_along)
  - [Repeat character strings with `strrep()`](#repeat-character-strings-with-strrep)
  - [Create an empty list of a given length](#create-an-empty-list-of-a-given-length)
  - [Create and assigning S3 classes in one step](#create-and-assigning-s3-classes-in-one-step)
  - [Assign names to vector elements or data frame columns at creation](#assign-names-to-vector-elements-or-data-frame-columns-at-creation)
  - [Use `I()` to include objects as is in data frames](#use-i-to-include-objects-as-is-in-data-frames)
  - [Generate factors using `gl()`](#generate-factors-using-gl)
- [Object transformation](#object-transformation)
  - [Insert elements into a vector with `append()`](#insert-elements-into-a-vector-with-append)
  - [Modify data frames with `transform()`](#modify-data-frames-with-transform)
  - [Modify data frames with `within()`](#modify-data-frames-with-within)
  - [Use `[` and `[[` as functions in apply calls](#use--and--as-functions-in-apply-calls)
  - [Sum all components in a list](#sum-all-components-in-a-list)
  - [Bind multiple data frames in a list](#bind-multiple-data-frames-in-a-list)
  - [Use `modifyList()` to update a list](#use-modifylist-to-update-a-list)
  - [Use `aperm()` and `asplit()` to permute and split arrays](#use-aperm-and-asplit-to-permute-and-split-arrays)
  - [Run-length encoding](#run-length-encoding)
- [Conditions](#conditions)
  - [Use `inherits()` for class checking](#use-inherits-for-class-checking)
  - [Replace multiple `ifelse()` with `cut()`](#replace-multiple-ifelse-with-cut)
  - [Simplify recoding categorical values with `factor()`](#simplify-recoding-categorical-values-with-factor)
  - [Save the number of `if` conditions with upcasting](#save-the-number-of-if-conditions-with-upcasting)
  - [Use `findInterval()` for many breakpoints](#use-findinterval-for-many-breakpoints)
- [Vectorization](#vectorization)
  - [Use `match()` for fast lookups](#use-match-for-fast-lookups)
  - [Use environments as fast key-value stores for fast lookups](#use-environments-as-fast-key-value-stores-for-fast-lookups)
  - [Use `mapply()` for element-wise operations on multiple lists](#use-mapply-for-element-wise-operations-on-multiple-lists)
  - [Simplify element-wise min and max operations with `pmin()` and `pmax()`](#simplify-element-wise-min-and-max-operations-with-pmin-and-pmax)
  - [Apply a function to all combinations of parameters](#apply-a-function-to-all-combinations-of-parameters)
  - [Generate all possible combinations of given characters](#generate-all-possible-combinations-of-given-characters)
  - [Vectorize a function with `Vectorize()`](#vectorize-a-function-with-vectorize)
  - [Pairwise computations using `outer()`](#pairwise-computations-using-outer)
  - [Subtract column means from non-zero elements in a sparse matrix](#subtract-column-means-from-non-zero-elements-in-a-sparse-matrix)
- [Functions](#functions)
  - [Specify formal argument lists with `alist()`](#specify-formal-argument-lists-with-alist)
  - [Use internal functions without `:::`](#use-internal-functions-without-)
- [Side-effects](#side-effects)
  - [Return invisibly with `invisible()` for side-effect functions](#return-invisibly-with-invisible-for-side-effect-functions)
  - [Use `on.exit()` for cleanup](#use-onexit-for-cleanup)
- [Numerical computations](#numerical-computations)
  - [Create step functions with `stepfun()`](#create-step-functions-with-stepfun)
- [Further reading](#further-reading)

## Object creation

### Create sequences with `seq_len()` and `seq_along()`

`seq_len()` and `seq_along()` are safer than `1:length(x)` or `1:nrow(x)`
because they avoid the unexpected result when `x` is of length `0`:

```r
# Safe version of 1:length(x)
seq_len(length(x))
# Safe version of 1:length(x)
seq_along(x)
```

### Repeat character strings with `strrep()`

When you need to repeat a string a certain number of times, instead of using
the tedious pattern of `paste(rep("foo", 10), collapse = "")`, you can use
the `strrep()` function:

```r
strrep("foo", 10)
```

`strrep()` is vectorized, meaning that you can pass vectors as arguments and
it will return a vector of the same length as the first argument:

```r
fruits <- c("apple", "banana", "orange")
strrep(c("*"), nchar(fruits))
strrep(c("-", "=", "**"), nchar(fruits))
```

### Create an empty list of a given length

Use the `vector()` function to create an empty list of a specific length:

```r
x <- vector("list", length)
```

### Create and assigning S3 classes in one step

Avoid creating an object and assigning its class separately.
Instead, use the `structure()` function to do both at once:

```r
x <- structure(list(), class = "my_class")
```

Instead of:

```r
x <- list()
class(x) <- "my_class"
```

This makes the code more concise when returning an object of a specific class.

### Assign names to vector elements or data frame columns at creation

The `setNames()` function allows you to assign names to vector elements or
data frame columns during creation:

```r
x <- setNames(1:3, c("one", "two", "three"))
x <- setNames(data.frame(...), c("names", "of", "columns"))
```

### Use `I()` to include objects as is in data frames

The `I()` function allows you to include objects as is when creating data frames:

```r
df <- data.frame(x = I(list(1:10, letters)))
df$x
#> [[1]]
#>  [1]  1  2  3  4  5  6  7  8  9 10
#>
#> [[2]]
#>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m"
#> [14] "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
```

This creates a data frame with one column `x` that is a list of vectors.

### Generate factors using `gl()`

Create a vector with specific levels with `gl()` by specifying the levels
and the number of repetitions:

```r
gl(n = 2, k = 5, labels = c("Low", "High"))
#> [1] Low  Low  Low  Low  Low  High High High High High
#> Levels: Low High
```

The `gl()` function is particularly useful when setting up experiments
or simulations that involve categorical variables.

## Object transformation

### Insert elements into a vector with `append()`

When you need to insert elements into a vector at a specific position,
use `append()`. It has an argument `after` that specifies the position after
which the new elements should be inserted, defaulting to length of the vector
being appended to.

For example, To insert the numbers 4, 5, 6 between 1, 2, 3 and 7, 8, 9:

```r
x <- c(1, 2, 3, 7, 8, 9)
append(x, 4:6, after = 3)
#> [1] 1 2 3 4 5 6 7 8 9
```

Without `append()`, the solution would be more verbose and less readable:

```r
c(x[1:3], 4:6, x[4:length(x)])
#> [1] 1 2 3 4 5 6 7 8 9
```

When `after` is set to `0`, the new values are "appended" to the beginning of
the input vector:

```r
append(x, 4:6, after = 0)
#> [1] 4 5 6 1 2 3 7 8 9
```

### Modify data frames with `transform()`

When adding new columns or modifying existing columns in a data frame,
instead of assigning each column individually, use `transform()` to perform
multiple transformations in a single step:

```r
df <- data.frame(x = 1:5, y = 6:10)
transform(df, z = x + y, y = y * 2, w = sqrt(x))
```

This is more concise and readable compared to the alternative of
multiple assignments and repeating `df$`:

```r
df$z <- df$x + df$y
df$y <- df$y * 2
df$w <- sqrt(df$x)
```

### Modify data frames with `within()`

For more complex data transformations that involve multiple steps or
intermediate variables, consider using the `within()` function
(not to be confused with `with()`):

```r
df <- data.frame(x = 1:5, y = 6:10)

within(df, {
  y <- x / sum(x)
  z <- log(y)
  category <- ifelse(z > -2, "High", "Low")
})
```

Note that both `transform()` and `within()` return a modified copy of the
original data frame and does not change the original data frame,
unless you assign the result back.

### Use `[` and `[[` as functions in apply calls

When you need to extract the same element from each item in a list or
list-like object, you can leverage `[` and `[[` as functions
(they actually are!) within `lapply()` and `sapply()` calls.

Consider a list of named vectors:

```r
lst <- list(
  item1 = c(a = 1, b = 2, c = 3),
  item2 = c(a = 4, b = 5, c = 6),
  item3 = c(a = 7, b = 8, c = 9)
)

# Extract named element "a" using `[[`
element_a <- sapply(lst, `[[`, "a")

lst <- list(
  item1 = c(1, 2, 3),
  item2 = c(4, 5, 6),
  item3 = c(7, 8, 9)
)

# Extract first element using `[`
first_element <- sapply(lst, `[`, 1)
```

### Sum all components in a list

Use the `Reduce()` function with the infix function `+` to sum up all components
in a list:

```r
x <- Reduce("+", list)
```

### Bind multiple data frames in a list

The `do.call()` function with the `rbind` argument allows you to bind
multiple data frames in a list into one data frame:

```r
df_combined <- do.call("rbind", list_of_dfs)
```

Alternatively, more performant solutions for such operations are offered in
`data.table::rbindlist()` and `dplyr::bind_rows()`. See
[this article](https://rpubs.com/jimhester/rbind) for details.

### Use `modifyList()` to update a list

The `modifyList()` function allows you to easily update values in a list
without a verbose syntax:

```r
old_list <- list(a = 1, b = 2, c = 3)
new_vals <- list(a = 10, c = 30)
new_list <- modifyList(defaults, new_vals)
```

This can be very useful for maintaining and updating a set of
configuration parameters.

### Use `aperm()` and `asplit()` to permute and split arrays

Use `aperm()` and `asplit()` to avoid nested for-loops in array manipulation.
`aperm()` is the generalization of matrix transpose. `asplit()` can split along
any array dimension.

```r
arr <- array(
  1:24,
  dim = c(2, 3, 4),
  dimnames = list(
    row = paste0("R", 1:2),
    col = paste0("C", 1:3),
    slice = paste0("S", 1:4)
  )
)

# Rearrange dimensions from (2 x 3 x 4) to (4 x 3 x 2)
aperm(arr, perm = c(3, 2, 1))

# Split into a length-4 list of (2 x 3) matrices
asplit(arr, MARGIN = 3)
```

### Run-length encoding

Run-length encoding is a simple form of data compression in which sequences
of the same element are replaced by a single instance of the element followed
by the number of times it appears in the sequence.

Suppose you have a vector with many repeating elements:

```r
x <- c(1, 1, 1, 2, 2, 3, 3, 3, 3, 2, 2, 2, 1, 1)
```

You can use `rle()` to compress this vector and decompress the result back
into the original vector with `inverse.rle()`:

```r
x <- c(1, 1, 1, 2, 2, 3, 3, 3, 3, 2, 2, 2, 1, 1)

(y <- rle(x))
#> Run Length Encoding
#>   lengths: int [1:5] 3 2 4 3 2
#>   values : num [1:5] 1 2 3 2 1

inverse.rle(y)
#> [1] 1 1 1 2 2 3 3 3 3 2 2 2 1 1
```

## Conditions

### Use `inherits()` for class checking

Instead of using the `class()` function in conjunction with `==`, `!=`,
or `%in%` operators to check if an object belongs to a certain class,
use the `inherits()` function.

```r
if (inherits(x, "class"))
```

This will return `TRUE` if "class" is one of the classes from which `x` inherits.
This replaces the following more verbose forms:

```r
if (class(x) == "class")
```

or

```r
if (class(x) %in% c("class1", "class2"))
```

It is also more reliable because it checks for class inheritance,
not just the first class name (R supports multiple classes for S3 and S4 objects).

### Replace multiple `ifelse()` with `cut()`

For a series of range-based conditions, use `cut()` instead of chaining
multiple `if-else` conditions or `ifelse()` calls:

```r
categories <- cut(
  x,
  breaks = c(-Inf, 0, 10, Inf),
  labels = c("negative", "small", "large")
)
```

This assigns each element in `x` to the category that corresponds to the
range it falls in.

### Simplify recoding categorical values with `factor()`

When dealing with categorical variables, you might need to replace or
recode certain levels. This can be achieved using chained `ifelse()` statements,
but a more efficient and readable approach is to use the `factor()` function:

```r
x <- c("M", "F", "F", NA)

factor(
  x,
  levels = c("F", "M", NA),
  labels = c("Female", "Male", "Missing"),
  exclude = NULL # Include missing values in the levels
)
```

### Save the number of `if` conditions with upcasting

Sometimes, the number of conditions checked in multiple `if` statements
can be reduced by cleverly using the fact that in R,
`TRUE` is upcasted to `1` and `FALSE` to `0` in numeric contexts.
This can be useful for selecting an index based on a set of conditions:

```r
i <- (width >= 960) + (width >= 1140) + 1
p <- p + facet_wrap(vars(class), ncol = c(1, 2, 4)[i])
```

This does the same thing as the following code, but in a much more concise way:

```r
if (width >= 1140) p <- p + facet_wrap(vars(class), ncol = 4)
if (width >= 960 & width < 1140) p <- p + facet_wrap(vars(class), ncol = 2)
if (width < 960) p <- p + facet_wrap(vars(class), ncol = 1)
```

This works because the condition checks in the parentheses result in a
`TRUE` or `FALSE`, and when they are added together, they are
upcasted to `1` or `0`.

### Use `findInterval()` for many breakpoints

If you want to assign a variable to many different groups or intervals,
instead of using a series of `if` statements, you can use the
`findInterval()` function. Using the same example above:

```r
breakpoints <- c(960, 1140)
ncols <- c(1, 2, 4)
i <- findInterval(width, breakpoints) + 1
p <- p + facet_wrap(vars(class), ncol = ncols[i])
```

The `findInterval()` function finds which interval each number in a
given vector falls into and returns a vector of interval indices.
It's a faster alternative when there are many breakpoints.

## Vectorization

### Use `match()` for fast lookups

The `match()` function can be faster than `which()` for looking up
values in a vector:

```r
index <- match(value, my_vector)
```

This code sets `index` to the index of `value` in `my_vector`.

### Use environments as fast key-value stores for fast lookups

Hashed environments created by `new.env(hash = TRUE)` can be used as fast
key–value store (hash tables).

Lookups (to check if a key exists) are effectively O(1) in a hashed environment
versus O(N) when using a regular list with `names()`.
This makes it a much faster and more memory-friendly choice than lists or
named vectors for determining if "something already exists".

```r
# Generate keys
set.seed(42)

n_keys <- 100000
keys <- replicate(n_keys, paste0(sample(letters, 10, replace = TRUE), collapse = ""))

# Store in a hashed environment
hash_env <- new.env(hash = TRUE, size = n_keys)
for (k in keys) hash_env[[k]] <- TRUE

# Store in a named list
my_list <- vector("list", length(keys))
names(my_list) <- keys

# Benchmark
n_tests <- 50000
test_keys <- sample(keys, n_tests, replace = TRUE)

system.time(for (k in test_keys) invisible(exists(k, envir = hash_env, inherits = FALSE)))
#  user  system elapsed
# 0.044   0.000   0.045
system.time(for (k in test_keys) invisible(k %in% names(my_list)))
#   user  system elapsed
# 29.518   2.026  32.129
```

### Use `mapply()` for element-wise operations on multiple lists

`mapply()` applies a function over a set of lists in an element-wise fashion:

```r
mapply(sum, list1, list2, list3)
```

### Simplify element-wise min and max operations with `pmin()` and `pmax()`

When comparing two or more vectors on an element-wise basis and get the
minimum or maximum of each set of elements, use `pmin()` and `pmax()`.

```r
vec1 <- c(1, 5, 3, 9, 5)
vec2 <- c(4, 2, 8, 1, 7)

# Instead of using sapply() or a loop:
sapply(1:length(vec1), function(i) min(vec1[i], vec2[i]))
sapply(1:length(vec1), function(i) max(vec1[i], vec2[i]))

# Use pmin() and pmax() for a more concise and efficient solution:
pmin(vec1, vec2)
pmax(vec1, vec2)
```

`pmin()` and `pmax()` perform these operations much more efficiently than
alternatives such as applying `min()` and `max()` in a loop or using `sapply()`.
This can lead to a noticeable performance improvement when working with large vectors.

### Apply a function to all combinations of parameters

Sometimes we need to run a function on every combination of a set of
parameter values, for example, in grid search. We can use the combination of
`expand.grid()`, `mapply()`, and `do.call()` + `rbind()` to accomplish this.

Suppose we have a simple function that takes two parameters, `a` and `b`:

```r
f <- function(a, b) {
  result <- a * b
  data.frame(a = a, b = b, result = result)
}
```

Create a grid of `a` and `b` parameter values to evaluate:

```r
params <- expand.grid(a = 1:3, b = 4:6)
```

We use `mapply()` to apply `f` to each row of our parameter grid.
We will use `SIMPLIFY = FALSE` to keep the results as a list of data frames:

```r
lst <- mapply(f, a = params$a, b = params$b, SIMPLIFY = FALSE)
```

Finally, we bind all the result data frames together into one final data frame:

```r
do.call(rbind, lst)
```

### Generate all possible combinations of given characters

To generate all possible combinations of a given set of characters,
`expand.grid()` and `do.call()` with `paste0()` can help.
The following snippet produces all possible three-digit character
strings consisting of both letters (lowercase) and numbers:

```r
x <- c(letters, 0:9)
do.call(paste0, expand.grid(x, x, x))
```

Here, `expand.grid()` generates a data frame where each row is a unique
combination of three elements from `x`. Then, `do.call(paste0, ...)`
concatenates each combination together into a string.

### Vectorize a function with `Vectorize()`

If a function is not natively vectorized (it has arguments that only take
one value at a time), you can use `Vectorize()` to create a new function
that accepts vector inputs:

```r
f <- function(x) x^2
lower <- c(1, 2, 3)
upper <- c(4, 5, 6)

integrate_vec <- Vectorize(integrate, vectorize.args = c("lower", "upper"))

result <- integrate_vec(f, lower, upper)
unlist(result["value", ])
```

The `Vectorize()` function works internally by leveraging the `mapply()`
function, which applies a function over two or more vectors or lists.

### Pairwise computations using `outer()`

The `outer()` function is useful for applying a function to every pair of
elements from two vectors. This can be particularly useful for U-statistics
and other situations requiring pairwise computations.

Consider two vectors of numeric values for which we wish to compute a
custom function for each pair:

```r
x <- rnorm(5)
y <- rnorm(5)

outer(x, y, FUN = function(x, y) x + x^2 - y)
```

### Subtract column means from non-zero elements in a sparse matrix

Here are three methods to achieve this, with increasing levels of optimization.

```r
library(Matrix)

set.seed(42)
mat <- rsparsematrix(nrow = 1000, ncol = 500, density = 0.01)
```

**Method 1**. Loop over columns and subtract the mean for non-zero elements:

```r
f1 <- function(mat) {
  col_means <- colSums(mat) / colSums(mat != 0)
  for (i in seq_len(ncol(mat))) {
    mat[mat[, i] != 0, i] <- mat[mat[, i] != 0, i] - col_means[i]
  }
  mat
}
```

**Method 2**. Use a helper matrix to subtract column means with matrix multiplication:

```r
f2 <- function(mat) {
  mat_copy <- mat
  mat_copy@x <- rep(1, length(mat_copy@x))
  col_means <- colSums(mat) / colSums(mat_copy)
  mat - mat_copy %*% Diagonal(x = col_means)
}
```

**Method 3**. Modify sparse matrix non-zero values directly:

```r
f3 <- function(mat) {
  col_means <- colSums(mat) / colSums(mat != 0)
  mat@x <- mat@x - rep(col_means, diff(mat@p))
  mat
}
```

```r
microbenchmark::microbenchmark(f1(mat), f2(mat), f3(mat), times = 100)
#> Unit: microseconds
#>     expr        min          lq        mean      median         uq        max
#>  f1(mat) 110731.242 113995.1290 133040.4843 115918.4595 119605.159 263641.562
#>  f2(mat)    473.509    504.6280    680.0215    571.9705    602.659   4543.620
#>  f3(mat)    172.446    192.5155    278.6069    238.0460    259.448   3965.356
```

The speedup is achieved by avoiding making redundant copies (from R's
copy-on-modify semantics) and making in-place modifications as much as possible.

## Functions

### Specify formal argument lists with `alist()`

The `alist()` function can create lists where some elements are intentionally
left blank (or are "missing"), which can be helpful when we want to specify
formal arguments of a function, especially in conjunction with `formals()`.

Consider this scenario. Suppose we are writing a function that wraps another
function, and we want our wrapper function to have the same formal arguments
as the original function, even if it does not use all of them.
Here is how we can use `alist()` to achieve that:

```r
original_function <- function(a, b, c = 3, d = "something") a + b

wrapper_function <- function(...) {
  # Use the formals of the original function
  arguments <- match.call(expand.dots = FALSE)$...

  # Update the formals using `alist()`
  formals(wrapper_function) <- alist(a = , b = , c = 3, d = "something")

  # Call the original function
  do.call(original_function, arguments)
}
```

Now, `wrapper_function()` has the same formal arguments as
`original_function()`, and any arguments passed to `wrapper_function()`
are forwarded to `original_function()`. This way, even if `wrapper_function()`
does not use all the arguments, it can still accept them, and code that uses
`wrapper_function()` can be more consistent with code that uses
`original_function()`.

The `alist()` function is used here to create a list of formals where
some elements are missing, which represents the fact that some arguments
are required and have no default values. This would not be possible
with `list()`, which cannot create lists with missing elements.

### Use internal functions without `:::`

To use internal functions from packages without using `:::`, you can use

```r
f <- utils::getFromNamespace("f", ns = "package")
f(...)
```

## Side-effects

### Return invisibly with `invisible()` for side-effect functions

R functions always return a value. However, some functions are primarily
designed for their side effects. To suppress the automatic printing
of the returned value, use `invisible()`.

```r
f <- function(x) {
  print(x^2)
  invisible(x)
}
```

The value of `x` can be used later when the result is assigned to a variable
or piped into the next function.

### Use `on.exit()` for cleanup

`on.exit()` is a useful function for cleaning up side effects, such as
deleting temporary files or closing opened connections, even if a function
exits early due to an error:

```r
f <- function() {
  temp_file <- tempfile()
  on.exit(unlink(temp_file))

  # Do stuff with temp_file
}

f <- function(file) {
  con <- file(file, "r")
  on.exit(close(con))
  readLines(con)
}
```

This function creates a temporary file and then ensures it gets deleted
when the function exits, regardless of why it exits. Note that the arguments
`add` and `after` in `on.exit()` are important for controlling the overwriting
and ordering behavior of the expressions.

## Numerical computations

### Create step functions with `stepfun()`

The `stepfun()` function is an effective tool for creating step functions,
which can be particularly handy in survival analysis.
For instance, say we have two survival curves generated from Kaplan-Meier
estimators, and we want to determine the difference in survival probabilities
at a given time.

Create the survival curves using `survfit()`:

```r
library("survival")

fit_km <- survfit(Surv(stop, event == "pcm") ~ 1, data = mgus1, subset = (start == 0))
fit_cr <- survfit(Surv(stop, event == "death") ~ 1, data = mgus1, subset = (start == 0))
```

Convert these survival curves into step functions:

```r
step_km <- stepfun(fit_km$time, c(1, fit_km$surv))
step_cr <- stepfun(fit_cr$time, c(1, fit_cr$surv))
```

With these step functions, it becomes straightforward to compute the
difference in survival probabilities at specific times:

```r
t <- 1:3 * 1000
step_km(t) - step_cr(t)
```

## Further reading

- [Data Manipulation with R](https://doi.org/10.1007/978-0-387-74731-6)
- [The R Inferno](https://www.burns-stat.com/documents/books/the-r-inferno/)
- [stackoverflow: Stack Overflow's Greatest Hits](https://cran.r-project.org/package=stackoverflow)

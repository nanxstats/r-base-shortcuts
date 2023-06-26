# r-base-shortcuts

A collection of lesser-known but powerful base R idioms and shortcuts
for writing concise and fast base R code, useful for beginner level to
intermediate level R developers.

> Why?
>
> From 2012 to 2022, I answered approximately 3,000 R questions in the
> online community [Capital of Statistics](https://d.cosx.org/).
> These recipes are observed and digested from the recurring patterns
> I learned from the frequently asked questions with less common answers.

## Contents

- [Object creation](#object-creation)
  - [Create and assigning S3 classes in one step](#create-and-assigning-s3-classes-in-one-step)
  - [Assign names to vector elements or data frame columns at creation](#assign-names-to-vector-elements-or-data-frame-columns-at-creation)
  - [Create an empty list of a given length](#create-an-empty-list-of-a-given-length)
  - [Create sequences with `seq_len()` and `seq_along()`](#create-sequences-with-seq_len-and-seq_along)
- [Object transformation](#object-transformation)
  - [Sum all components in a list](#sum-all-components-in-a-list)
  - [Bind multiple data frames in a list](#bind-multiple-data-frames-in-a-list)
- [Object representation](#object-representation)
  - [Run-length encoding](#run-length-encoding)
- [Conditions](#conditions)
  - [Use `inherits()` for class checking](#use-inherits-for-class-checking)
  - [Save the number of `if` conditions with upcasting](#save-the-number-of-if-conditions-with-upcasting)
  - [Use `findInterval()` for many breakpoints](#use-findinterval-for-many-breakpoints)
- [Vectorization](#vectorization)
  - [Vectorize a function with `Vectorize()`](#vectorize-a-function-with-vectorize)

## Object creation

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

### Assign names to vector elements or data frame columns at creation

The `setNames()` function allows you to assign names to vector elements or
data frame columns during creation:

```r
x <- setNames(data.frame(...), c("names", "of", "elements"))
```

Instead of:

```r
x <- data.frame()
names(x) <- c("names", "of", "elements")
```

### Create an empty list of a given length

Use the `vector()` function to create an empty list of a specific length:

```r
x <- vector("list", length)
```

### Create sequences with `seq_len()` and `seq_along()`

`seq_len()` and `seq_along()` are safer than `1:length(x)` or `1:nrow(x)`
because they avoid the unexpected result when `x` is of length `0`:

```r
# Safe version of 1:length(x)
seq_len(length(x))
# Safe version of 1:length(x)
seq_along(x)
```

## Object transformation

### Sum all components in a list

Use the `Reduce()` function with the `+` operator to sum up all components
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

## Object representation

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

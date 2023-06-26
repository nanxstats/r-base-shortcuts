# r-base-shortcuts

From 2012 to 2022, I answered approximately 3,000 R questions in the
online community [Capital of Statistics](https://d.cosx.org/).
Digested from the repeated patterns I learned from answering the questions,
here is a collection of lesser-known but powerful base R idioms and shortcuts.

I hope these shortcuts are useful for beginner to intermediate level folks
who want to write concise and fast base R code.

## Contents

- [Creating and assigning S3 classes in one step](#creating-and-assigning-s3-classes-in-one-step)
- [Assigning names to vector elements or data frame columns at creation](#assigning-names-to-vector-elements-or-data-frame-columns-at-creation)
- [Creating an empty list of a given length](#creating-an-empty-list-of-a-given-length)
- [Summing all components in a list](#summing-all-components-in-a-list)
- [Binding multiple data frames in a list](#binding-multiple-data-frames-in-a-list)
- [Run-length encoding](#run-length-encoding)

## Creating and assigning S3 classes in one step

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

## Assigning names to vector elements or data frame columns at creation

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

## Creating an empty list of a given length

Use the `vector()` function to create an empty list of a specific length:

```r
x <- vector("list", length)
```

## Summing all components in a list

Use the `Reduce()` function with the `+` operator to sum up all components
in a list:

```r
x <- Reduce("+", list)
```

## Binding multiple data frames in a list

The `do.call()` function with the `rbind` argument allows you to bind
multiple data frames in a list into one data frame:

```r
df_combined <- do.call("rbind", list_of_dfs)
```

## Run-length encoding

`rle()` stands for "run-length encoding". It's a simple form of data compression
in which sequences of the same element are replaced by a single instance of
the element followed by the number of times it appears in the sequence.
`inverse.rle()` is the counterpart of `rle()` and can decompress the data
back to its original form.

Suppose you have a vector with many repeating elements:

```r
x <- c(1, 1, 1, 2, 2, 3, 3, 3, 3, 2, 2, 2, 1, 1)
```

You can use `rle()` to compress this data and decompress the result back
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

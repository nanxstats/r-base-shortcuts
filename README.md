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

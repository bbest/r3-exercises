# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

#' Hello, {name}!
#'
#' Prints 'Hello, {name}!'
#'
#' @param name who to greet; defaults to "World"
#'
#' @return a string
#' @importFrom glue glue
#' @export
#'
#' @examples
#' hello()
hello <- function(name = "World") {
  print(glue::glue("Hello, {name}!"))
}

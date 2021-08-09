#' Time series plot
#'
#' Plot time series interactively.
#'
#' @param d data frame with two columns
#'
#' @return interactive dygraph plot
#' @import dygraphs
#' @export
#'
#' @examples
#' ts_plot(df_exp)
ts_plot <- function(d){
  dygraphs::dygraph(d) %>%
    dygraphs::dyRangeSelector()
}

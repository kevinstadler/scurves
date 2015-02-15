data <- read.table(system.file("extdata", "datasets.csv", package="scurves"), header=TRUE, sep="\t")

#' Return meta-information about one or all s-shaped-curves datasets
#'
#' @param datasets optional character vector of datasets that should be selected
#' @return a dataframe containing information about available s-curve datasets
#' @export
scurves <- function(datasets=NULL)
  if (is.null(datasets)) data else subset(data, id %in% datasets)

#' Returns the character labels for all competing variants in the given dataset.
#' 
#' The first element describes the outgoing variable, the second one the
#' incoming variable. Any further elements name other competing variants - these
#' strings are also the column names of those token counts in the datasets.
#' 
#' @param dataset the name of the dataset
#' @return a vector of at least two strings specifying the outgoing, incoming,
#'   and any other competing variants for the given dataset
#' @export
#' @seealso dataset
variants <- function(dataset)
  strsplit(scurves(dataset)$variants, ' ', fixed=T)[[1]]

#' Returns a dataframe containing all data from the dataset with the given id
#' 
#' @param id the name of the data set
#' @return a dataframe with data from the particular language change dataset
#' @export
dataset <- function(id) {
  d <- read.table(system.file("extdata", paste(id, ".csv", sep=""), package="scurves"), header=TRUE, sep="\t", colClasses=c(start="Date", end="Date"))
  # perform data consistency checks
  if (any(rowSums(d[4:(ncol(d)-1)]) != d$total, na.rm=T)) {
    warning(paste("Inconsistent token counts in dataset", id))
  }
  class(d) <- c("scurve", class(d))
  # here we could compute some extra columns dynamically
  #d$proportion <- d$incoming/d$total
  # compute mid-point of time period 
  #d$t <- mean(c(d$start, d$end))
  #d$t <- d$start+(d$end-d$start)/2
  return(d)
}

#' Generate a default plot for the dataset, overlaying all contexts
#' @export
#' @seealso plot.default
plot.scurve <- function(d, contexts=levels(d$context), type="l", lty=1, colfun=rainbow, cols=colfun(length(contexts)), ...) {
  par(new=F)
  col <- 1
  for (c in contexts) {
    s <- subset(d, context==c)
    plot.default(s$start+(s$end-s$start)/2, s$incoming/s$total, type=type, lty=lty, col=cols[col], xlim=c(min(d$start), max(d$end)), ylim=0:1, yaxs="i", xlab="", ylab="", ...)
    par(new=T, xaxt="n", yaxt="n")
    col <- col+1
  }
  mtext("date", 1, 3)
  mtext("Proportion of incoming variant", 2, 3)
  legend("topleft", title="Context", legend=contexts, lty=lty, col=cols)
}

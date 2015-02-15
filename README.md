# s-shaped curves in language change

> "The logistic curve stands out in the history of population ecology as one of the more fruitful and at the same time unsatisfactory models of population growth."
> -- <cite>Kingsland 1982</cite>

a repository of longitudinal data on language changes extracted from the literature, and 1.000 ways to fit s-shaped curves to them.

# Usage

The tab-separated files containing the individual datasets can be found in the [inst/extdata](https://github.com/kevinstadler/s-shaped-curves/tree/master/inst/extdata) directory.

Meta-information on all the datasets present and future (such as the number of competing variants, names of the main incoming/outgoing variants, datasets which we still want to add, etc.) can be found in [datasets.csv](https://github.com/kevinstadler/s-shaped-curves/blob/master/inst/extdata/datasets.csv).

This github repository also provides an R package called `scurves` which allows easy access to the datasets. To install it from within R you will need the `devtools` package:

    devtools::install_github("kevinstadler/s-shaped-curves")
    # get information on all available datasets
    scurves::scurves()
    # load a specific data set
    dosupport <- scurves::dataset("Ell53")
    # produce a nice plot
    plot(dosupport)

# Format

The individual data set files in this repository:

* use tabs as separating characters between columns
* can contain comments, using `#` as comment character
* may contain blank lines
* contain a header line specifying the column names
* contain the following columns (in this order):
  * `context`:  factor for grouping token counts from the same period by different linguistic contexts, can be `NA`
  * `start`:    start date of the observation period, in format yyyy-mm-dd
  * `end`:      end date of the observation period, in format yyyy-mm-dd
  * `outgoing`: total count of tokens of the main outgoing variant in that period
  * `incoming`: total count of tokens of the main incoming variant in that period
  * `total`: total count of tokens for that period. It is typically but not necessarily the case that outgoing+incoming=total, since there might be more competing variants.

Additionally, individual files may contain any number of extra columns between the 'incoming' and 'total' column to specify token counts for other competing variants which were neither the dominating variant at the beginning nor the dominating variant at the end of the change. The names of these columns can be choosen freely to reflect the actual variants, e.g. 'mie', 'point' etc. for the case of French negation markers. The names of these additional columns are also reported in the `datasets.csv` metadata file to ease automatic processing.

The files can be read into R using the following command:

    d <- read.table("filename.csv", sep="\t", header=TRUE, colClasses=c(start="Date", end="Date"))

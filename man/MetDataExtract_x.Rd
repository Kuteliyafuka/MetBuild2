% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MetDataExtract_x.R
\name{MetDataExtract_x}
\alias{MetDataExtract_x}
\title{extract data from the list of GSE objects}
\usage{
MetDataExtract_x(geo_list, additional_age_colnames = character())
}
\arguments{
\item{geo_list}{the result of the MetDataDownload}

\item{additional_age_colnames}{character vector of possible age_column_names}

\item{dataset_names}{character vector}
}
\value{
list of GSE objects
}
\description{
to extract β value matrix and age information from GSE objects.
then organize these data, preparing them for downstream analysis
the column name of age in pheno_data is not certain, so it is recommended to check the annotation file first.
we only consider "age:ch1","age (y):ch1" these two names
though dataset_names should be omitted, I do not make it for my laziness :).
}
\examples{
MetDataExtract(geo_list,datasets_names)

}

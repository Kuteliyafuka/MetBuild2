#' download illumina 450k methylation data from GEO
#' @description
#' to download data from GEO database, it may take a long time due to the large amount of data.
#' also, in some versions of GEOquery packages, the getGEO function only allow for download in 2 minutes.
#' in that case, it is  recommended to download data by hands or update the version of GEOquery.
#'
#'
#' @param dataset_names character vector
#' @return list of GSE objects
#' @export
#' @examples
#' MetDataDownload(c('GSE40279','GSE67705'))
#'




MetDataDownload <- function(datasets_names){
  geo_list <- list()
  for (selected_ds in datasets_names){
    message("Downloading:",selected_ds)
    geo_list[[selected_ds]] <- GEOquery::getGEO(selected_ds,GSEMatrix = TRUE)
    Sys.sleep(10)
  }
  return(geo_list)
}

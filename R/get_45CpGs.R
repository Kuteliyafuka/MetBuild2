#' extract data from the list of GSE objects
#' @description
#' get 45CpGsites
#'
#'

#' @return character vector
#' @export
#' @examples
#' get_45CpGs()
#'

get_45CpGs <- function(){
  file_path <- system.file("extdata", "45CpG_sites.txt", package = "your_package")
  return(file_path)

}

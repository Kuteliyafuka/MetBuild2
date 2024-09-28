#' get_model
#' @description
#' get elastic net model
#'
#'

#' @return character vector
#' @export
#' @examples
#' get_model()
#'

get_model <- function(){
  file_path <- system.file("extdata", "Elastic.rds", package = "your_package")
  ElasticNetModel <- readRDS(file_path)

  return(ElasticNetModel)
}

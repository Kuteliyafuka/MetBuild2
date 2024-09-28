#' extract data from the list of GSE objects
#' @description
#' to extract β value matrix and age information from GSE objects.
#' then organize these data, preparing them for downstream analysis
#' the column name of age in pheno_data is not certain, so it is recommended to check the annotation file first.
#' we only consider "age:ch1","age (y):ch1" these two names
#' though dataset_names should be omitted, I do not make it for my laziness :).
#'
#'
#' @param geo_list the result of the MetDataDownload
#' @param dataset_names character vector
#' @param additional_age_colnames  character vector of possible age_column_names
#' @return list of GSE objects
#' @export
#' @examples
#' MetDataExtract(geo_list,datasets_names)
#'

MetDataExtract_x <- function(geo_list, additional_age_colnames = character()){
  #数据预处理，提取β值矩阵，转置，去缺失值
  datasets_names <- names(geo_list)
  all_list <- list()
  pheno_list <- list()
  beta_value_list <- list()
  for (selected_ds in datasets_names){
    #β矩阵预处理
    beta_matrix_raw <- Biobase::exprs(geo_list[[selected_ds]][[1]])
    beta_matrix_rawt <- t(beta_matrix_raw)
    beta_matrix_selectedCpGs <- beta_matrix_rawt
    beta_matrix_new <- na.omit(beta_matrix_selectedCpGs)
    beta_value_list[[selected_ds]] <- beta_matrix_new
    Sys.sleep(10)
  }

  #得到年龄信息并将其和β矩阵合并起来
  #年龄的列名可能会有别的写法，因此有报错的可能
  age_columns <- c("age:ch1","age (y):ch1")
  age_columns <- c(age_columns,additional_age_colnames)
  for (selected_ds in datasets_names){
    #年龄预处理
    pheno_data <- Biobase::pData(geo_list[[selected_ds]][[1]])
    age_data <- pheno_data[,colnames(pheno_data) %in% age_columns,drop = FALSE]
    age_data <- na.omit(age_data)
    all_data <- merge(age_data,beta_value_list[[selected_ds]],by = "row.names")
    all_list[[selected_ds]] <- all_data
    Sys.sleep(10)
  }
  return(all_list)

}

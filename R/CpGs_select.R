#' extract data from the list of GSE objects
#' @description
#' to extract β value matrix and age information from GSE objects.
#' then organize these data, preparing them for downstream analysis
#' the column name of age in pheno_data is not certain, so it is recommended to check the annotation file first.
#' we only consider "age:ch1","age (y):ch1" these two names
#' though dataset_names should be omitted, I do not make it for my laziness :).
#'
#'
#' @param mergedData the result of the MetDataExtracted
#' @param top_CpGs_number numeric
#' @return character vector of the probeID
#' @export
#' @examples
#' CpGs_select(mergedData,top_CpGs_number = 20)
#'

CpGs_select <- function(mergedData,top_CpGs_number = 20){

  spearman_results <- c()
  for (col in colnames(mergedData)[-1]) {
    spearman_results[col] <- cor(mergedData[,1], mergedData[[col]], method = "spearman")
  }
  df_spear = data.frame(spearman_results)
  df_spear['abs_spearman'] = abs(df_spear['spearman_results'])
  df_spear = df_spear[order(-df_spear$abs_spearman),]
  df_spear = df_spear[1:top_CpGs_number,]
  print(df_spear)
  selected_CpGs = rownames(df_spear)
  return(selected_CpGs)

}

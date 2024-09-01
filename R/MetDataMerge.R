#' merge all the samples
#' @description
#' merge all the samples into one dataframe
#'
#' @param all_list the list got from MetDataExtract
#' @param dataset_names character vector
#' @return a dataframe ready for model training
#' @export
#' @examples
#' MetDataMerge(all_list,datasets_names)



MetDataMerge <- function(all_list){
  datasets_names <- names(all_list)
  #这一步的年龄列列名需要保证是`age:ch1`
  merge_df <- all_list[[1]][1,]
  for (selected_ds in datasets_names){
    colnames(all_list[[selected_ds]]) <- colnames(merge_df)
    merge_df <- rbind(merge_df,all_list[[selected_ds]])
    Sys.sleep(10)
  }
  merge_df[,2] <- as.integer(merge_df[,2])
  merge_df <- na.omit(merge_df)
  merge_df <- merge_df[-1,]
  rownames(merge_df) <- merge_df[,1]
  dat <- merge_df[,-1]
  return(dat)
}

#' divide samples for trainSet and testSet
#' @description
#' since the data is ready for the model construction, now we prepare the trainSet and testSet
#'
#' @param dat the dataframe as a result of MetDataMerge
#' @return the four parts contain beta_matrix_train,beta_matrix_test,age_train,age_test
#' @export
#' @examples
#' MetDataPartition(dat)


MetDataPartition <- function(dat,trainProportion = 0.8){
  trainIndex <- caret::createDataPartition(dat$`age:ch1`,p = trainProportion,list = FALSE)
  trainSet <- dat[trainIndex,]
  testSet <- dat[-trainIndex,]
  beta_matrix_train <- as.matrix(trainSet[,-1])
  beta_matrix_test <- as.matrix(testSet[,-1])
  age_train <- trainSet$`age:ch1`
  age_test <- testSet$`age:ch1`
  PartitionedData <- list(trainSet,testSet,age_train,age_test)
  names(PartitionedData) <- c('trainSet','testSet','age_train','age_test')
  return(PartitionedData)

}


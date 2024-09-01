#' multiple-variate regression
#' @description
#' to build a multiple-variate regression model
#'
#'
#' @param PartitionedData list
#' @return MultiRegressionmodel
#' @export
#' @examples
#' MetDataMultiRegression(PartitionedData)
#'
#'




MetDataMultiRegression<- function(PartitionedData){
  #模型训练
  trainSet <- PartitionedData[['trainSet']]
  colnames(trainSet)[1] <- 'y'
  CpG_names <- colnames(trainSet)[-1]
  multiple_regression_formula_string <- paste("y ~",paste(CpG_names,collapse = "+"))
  multiple_regression_formula <- as.formula(multiple_regression_formula_string)
  MultiRegression <- lm(multiple_regression_formula,data = trainSet_multiRegression)
  return(MultiRegression)

}

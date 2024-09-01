#' lasso model construction
#' @description
#' build a lasso model by glmnet
#'
#'
#' @param beta_matrix_train beta value matrix
#' @param age_train numeric vector
#' @return lasso model
#' @export
#' @examples
#' MetDataTrainLasso(beta_matrix_train, age_train,para_alpha = 1)
#'

MetDataTrainLasso <- function(PartitionedData){
  #模型训练
  trainSet <- PartitionedData[['trainSet']]
  beta_matrix_train <- as.matrix(trainSet[,-1])
  age_train <- PartitionedData[['age_train']]
  glmnet.Training.CV = glmnet::cv.glmnet(beta_matrix_train, age_train, nfolds=10,alpha = 1,family="gaussian")
  lambda.glmnet.Training = glmnet.Training.CV$lambda.min
  glmnet.Training = glmnet::glmnet(beta_matrix_train, age_train, family="gaussian",alpha = 1,nlambda=100)
  return(glmnet.Training)
}




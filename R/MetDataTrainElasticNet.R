#' elastic net model construction
#' @description
#' build a elastic net by glmnet, the default alpha value is 0.5
#'
#'
#' @param beta_matrix_train beta value matrix
#' @param age_train numeric vector
#' @return elastic net model
#' @export
#' @examples
#' MetDataTrainElasticNet(beta_matrix_train, age_train,para_alpha = 0.5)
#'

MetDataTrainElasticNet <- function(PartitionedData,para_alpha = 0.5){
  #模型训练
  trainSet <- PartitionedData[['trainSet']]
  beta_matrix_train <- as.matrix(trainSet[,-1])
  glmnet.Training.CV = glmnet::cv.glmnet(beta_matrix_train, PartitionedData[['age_train']], nfolds=10,alpha = para_alpha,family="gaussian")
  lambda.glmnet.Training = glmnet.Training.CV$lambda.min
  glmnet.Training = glmnet::glmnet(beta_matrix_train, PartitionedData[['age_train']], family="gaussian",alpha = para_alpha,nlambda=100)
  return(glmnet.Training)
}


getwd()

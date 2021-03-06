context("Seed")
smalltoyml <- create_subset(toyml, seq(3, 100, 3))

testTrainMethod <- function (method, name, ...) {
  name <- paste(name, "Training")
  if (parallel::detectCores() <= 1 | Sys.info()["sysname"] == "Windows") {
    skip(name)
    return(FALSE)
  }

  m1 <- method(smalltoyml, "SVM", ..., scale=FALSE, seed=123)
  set.seed(321)
  m2 <- method(smalltoyml, "SVM", ..., scale=FALSE, cores=1, seed=123)
  m3 <- method(smalltoyml, "SVM", ..., scale=FALSE, cores=2, seed=123)
  set.seed(345)
  m4 <- method(smalltoyml, "SVM", ..., scale=FALSE, cores=2, seed=123)

  r1 <- predict(m1, smalltoyml)
  r2 <- predict(m2, smalltoyml)
  r3 <- predict(m3, smalltoyml)
  r4 <- predict(m4, smalltoyml)
  expect_equal(r1, r2, label=name)
  expect_equal(r3, r4, label=name)
}

testPredictMethod <- function (method, name, ...) {
  name <- paste(name, "Prediction")
  if (parallel::detectCores() <= 1 | Sys.info()["sysname"] == "Windows") {
    skip(name)
    return(FALSE)
  }

  model <- method(smalltoyml, "RANDOM", ...)
  r1 <- predict(model, smalltoyml, seed=123)

  set.seed(321)
  r2 <- predict(model, smalltoyml, cores=1, seed=123)
  r3 <- predict(model, smalltoyml, cores=2, seed=123)

  set.seed(345)
  r4 <- predict(model, smalltoyml, cores=2, seed=123)

  expect_equal(r1, r2, label=name)
  expect_equal(r3, r4, label=name)
}

testSeedEffectMethod <- function (method, name, ...) {
  name <- paste(name, "Seed Effect")
  if (parallel::detectCores() <= 1 | Sys.info()["sysname"] == "Windows") {
    skip(name)
    return(FALSE)
  }

  set.seed(21)
  method(smalltoyml, "SVM", scale=FALSE, ..., seed=123)
  v1 <- stats::runif(5)

  set.seed(21)
  method(smalltoyml, "SVM", scale=FALSE, ..., seed=123)
  v2 <- stats::runif(5)

  set.seed(21)
  method(smalltoyml, "SVM", scale=FALSE, ..., cores=2, seed=123)
  v3 <- stats::runif(5)

  set.seed(21)
  method(smalltoyml, "SVM", scale=FALSE, ..., cores=2, seed=123)
  v4 <- stats::runif(5)

  expect_equal(v1, v2, label = name)
  expect_equal(v3, v4, label = name)
}

test_that("BR Test", {
  skip_on_cran()
  name <- "Binary Relevance"
  testTrainMethod(method=br, name=name)
  testPredictMethod(method=br, name=name)
  testSeedEffectMethod(method=br, name=name)
})

test_that("BRPlus Test", {
  skip_on_cran()
  name <- "Binary Relevance Plus"
  testTrainMethod(method=brplus, name=name)
  testPredictMethod(method=brplus, name=name)
  testSeedEffectMethod(method=brplus, name=name)
})

test_that("CC Test", {
  skip_on_cran()
  name <- "Classifier Chains"
  testTrainMethod(method=cc, name=name)
  testPredictMethod(method=cc, name=name)
  testSeedEffectMethod(method=cc, name=name)
})

test_that("DBR Test", {
  skip_on_cran()
  name <- "Dependent Binary Relevance"
  testTrainMethod(method=dbr, name=name)
  testPredictMethod(method=dbr, name=name)
  testSeedEffectMethod(method=dbr, name=name)
})

test_that("EBR Test", {
  skip_on_cran()
  name <- "Ensemble of Binary Relevance"
  testTrainMethod(method=ebr, name=name, m=3)
  testPredictMethod(method=ebr, name=name, m=3)
  testSeedEffectMethod(method=ebr, name=name, m=3)
})

test_that("ECC Test", {
  skip_on_cran()
  name <- "Ensemble of Classifier Chains"
  testTrainMethod(method=ecc, name=name, m=3)
  testPredictMethod(method=ecc, name=name, m=3)
  testSeedEffectMethod(method=ecc, name=name, m=3)
})

test_that("MBR Test", {
  skip_on_cran()
  name <- "Meta Binary Relevance"
  testTrainMethod(method=mbr, name=name)
  testPredictMethod(method=mbr, name=name)
  testSeedEffectMethod(method=mbr, name=name)
  name <-  "Meta Binary Relevance with folds"
  testTrainMethod(method=mbr, name=name, folds=3, phi=0.1)
  testPredictMethod(method=mbr, name=name, folds=3, phi=0.1)
  testSeedEffectMethod(method=mbr, name=name, folds=3, phi=0.1)
})

test_that("NS Test", {
  skip_on_cran()
  name <- "Nestest Stacking"
  testTrainMethod(method=ns, name=name)
  testPredictMethod(method=ns, name=name)
  testSeedEffectMethod(method=ns, name=name)
})

test_that("Prudent", {
  skip_on_cran()
  name <- "Prudent"
  testTrainMethod(method=prudent, name=name)
  testPredictMethod(method=prudent, name=name)
  testSeedEffectMethod(method=prudent, name=name)
})

test_that("RDBR Test", {
  skip_on_cran()
  name <- "Recursive Dependent Binary Relevance"
  testTrainMethod(method=rdbr, name=name)
  testPredictMethod(method=rdbr, name=name)
  testSeedEffectMethod(method=rdbr, name=name)
})

test_that("LIFT", {
  skip_on_cran()
  name <- "LIFT"
  testTrainMethod(method=lift, name=name)
  testPredictMethod(method=lift, name=name)
  testSeedEffectMethod(method=lift, name=name)
})

test_that("RPC", {
  skip_on_cran()
  name <- "RPC"
  testTrainMethod(method=rpc, name=name)
  testPredictMethod(method=rpc, name=name)
  testSeedEffectMethod(method=rpc, name=name)
})

test_that("CLR", {
  skip_on_cran()
  name <- "CLR"
  testTrainMethod(method=clr, name=name)
  testPredictMethod(method=clr, name=name)
  testSeedEffectMethod(method=clr, name=name)
})

test_that("LP", {
  skip_on_cran()
  name <- "LP"
  testTrainMethod(method=lp, name=name)
  testPredictMethod(method=lp, name=name)
  testSeedEffectMethod(method=lp, name=name)
})

test_that("RAkEL", {
  skip_on_cran()
  name <- "RAkEL"
  testTrainMethod(method=rakel, name=name)
  testPredictMethod(method=rakel, name=name)
  testSeedEffectMethod(method=rakel, name=name)
})

test_that("PPT", {
  skip_on_cran()
  name <- "PPT"
  testTrainMethod(method=ppt, name=name)
  testPredictMethod(method=ppt, name=name)
  testSeedEffectMethod(method=ppt, name=name)
})

test_that("PS", {
  skip_on_cran()
  name <- "PS"
  testTrainMethod(method=ps, name=name)
  testPredictMethod(method=ps, name=name)
  testSeedEffectMethod(method=ps, name=name)
})

test_that("EPS", {
  skip_on_cran()
  name <- "EPS"
  testTrainMethod(method=eps, name=name)
  testPredictMethod(method=eps, name=name)
  testSeedEffectMethod(method=eps, name=name)
})

test_that("HOMER", {
  skip_on_cran()
  name <- "HOMER"
  testTrainMethod(method=homer, name=name)
  testPredictMethod(method=homer, name=name)
  testSeedEffectMethod(method=homer, name=name)
})

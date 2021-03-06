#' @title Linear Model Regression Learner
#'
#' @usage NULL
#' @name mlr_learners_regr.lm
#' @format [R6::R6Class()] inheriting from [mlr3::LearnerRegr].
#'
#' @section Construction:
#' ```
#' LearnerRegrLM$new()
#' mlr3::mlr_learners$get("regr.lm")
#' mlr3::lrn("regr.lm")
#' ```
#'
#' @description
#' Ordinary linear regression.
#' Calls [stats::lm()].
#'
#' @export
#' @template seealso_learner
#' @templateVar learner_name regr.lm
#' @template example
LearnerRegrLM = R6Class("LearnerRegrLM", inherit = LearnerRegr,
  public = list(
    initialize = function() {
      super$initialize(
        id = "regr.lm", ,
        predict_types = c("response", "se"),
        feature_types = c("integer", "numeric", "factor"),
        properties = "weights",
        packages = "stats",
        man = "mlr3learners::mlr_learners_regr.lm"
      )
    },

    train_internal = function(task) {
      pars = self$param_set$get_values(tags = "train")
      if ("weights" %in% task$properties) {
        pars = insert_named(pars, list(weights = task$weights$weight))
      }

      invoke(stats::lm, formula = task$formula(), data = task$data(), .args = pars)
    },

    predict_internal = function(task) {
      newdata = task$data(cols = task$feature_names)

      if (self$predict_type == "response") {
        PredictionRegr$new(task = task, response = predict(self$model, newdata = newdata, se.fit = FALSE))
      } else {
        pred = predict(self$model, newdata = newdata, se.fit = TRUE)
        PredictionRegr$new(task = task, response = pred$fit, se = pred$se.fit)
      }
    }
  )
)

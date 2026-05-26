#' Evaluate pool of candidate parent matches based on multiple variables to identify "best" match
#'
#' @param baby_to_match data.frame (with one row) for a single baby that includes at least \code{key_baby} as a column.
#' @param parents_to_match data.frame (with multiple rows) for all potential parent matches that includes at least \code{key_parent} as a column.
#' @param key_baby string variable name(s) to match on from \code{baby_to_match}.
#' @param key_parent string variable name(s) to match on from \code{parents_to_match}.
#' @param id_parent string variable name to identify observations in \code{parents_to_match}.
#' @param jaro_col_name string variable name(s) for the added column of the Jaro similarity corresponding to the keys.
#' @param candidate_pool optional, vector of \code{id_parent} values returned by the \code{build_candidate_parent_pool} function.
#' @param deterministic_only optional, string variable name(s) in \code{key_baby} that should only undergo deterministic linkage.
#' @param aggregate_scores string for how scores should be aggregated across keys. Default is \code{aggregate_scores = "mean"}; other options are \code{"median"} and \code{"sum"}.
#' @return A list containing
#' \describe{
#'     \item{\code{best_candidate}}{A copy of the best-matching candidate from \code{parents_to_match} with added columns for
#'       the similarity scores per variable and aggregate.}
#'     \item{\code{all_candidates}}{A copy of alll candidates from \code{parents_to_match} with added columns for
#'       the similarity scores per variable and aggregate.}
#'   }
#' @export
evaluate_candidate_parent_pool = function(baby_to_match, parents_to_match, key_baby, key_parent, id_parent, jaro_col_name, candidate_pool = NULL, deterministic_only = NULL,  aggregate_scores = "mean") {
  ## Check for missing keys in baby data
  missing_keys = which(is.na(baby_to_match[key_baby]) | baby_to_match[key_baby] == "")
  ### And then remove them from all vectors
  if (length(missing_keys) > 0) {
    key_baby = key_baby[-missing_keys]
    key_parent = key_parent[-missing_keys]
    jaro_col_name = jaro_col_name[-missing_keys]
  }

  ## If not supplied...
  ### Build vector of candidate parents from "best" fits per variable
  if (is.null(candidate_pool)) {
    candidate_pool = build_candidate_parent_pool(
      baby_to_match = baby_to_match,
      parents_to_match = parents_to_match,
      key_baby = key_baby,
      key_parent = key_parent,
      id_parent = id_parent,
      jaro_col_name = jaro_col_name,
      deterministic_only = deterministic_only
    )
  }

  ## Subset parents_to_match to candidate pool
  candidates_parents_data = parents_to_match[parents_to_match[, id_parent] %in% candidate_pool, ]
  ### Keep only columns for the ID and matching keys
  candidates_parents_data = candidates_parents_data[, c(id_parent, unique(key_parent))]

  ## Calculate the similarity score per variable and per candidate parent
  return_candidates_parents_data = data.frame()
  for (c in 1:nrow(candidates_parents_data)) {
    ### Loop through keys
    candidates_parents_data_c = candidates_parents_data[c, ]
    for (k in 1:length(key_baby)) {
      #### Make sure key is not missing in baby's data
      if (!is.na(baby_to_match[key_baby[k]])) {
        ##### Do combined (deterministic --> probabilistic linkage)
        ###### Based on the kth baby/parent keys provided
        link_on_k = combined_baby_parent_linkage(
          baby_to_match = baby_to_match,
          parents_to_match = candidates_parents_data_c,
          key_baby = key_baby[k],
          key_parent = key_parent[k],
          jaro_col_name = jaro_col_name[k]
        )
        if (link_on_k$type == "deterministic") {
          link_on_k$match[, jaro_col_name[k]] = 1
        }
        ## Append the Jaro score to the end of the candidates' data
        candidates_parents_data_c = cbind(candidates_parents_data_c,
                                          link_on_k$match[, jaro_col_name[k]])
        colnames(candidates_parents_data_c)[ncol(candidates_parents_data_c)] = jaro_col_name[k]
      }
    }
    ### Stack/save candidate
    return_candidates_parents_data = rbind(return_candidates_parents_data,
                                           candidates_parents_data_c)
  }

  ## Calculate aggregate jaro scores per candidate
  if (aggregate_scores == "mean") {
    return_candidates_parents_data[, "jaro_aggregate"] = apply(
      X = return_candidates_parents_data[, jaro_col_name],
      MARGIN = 1,
      FUN = mean,
      simplify = TRUE)
  } else if (aggregate_scores == "median") {
    return_candidates_parents_data[, "jaro_aggregate"] = apply(
      X = return_candidates_parents_data[, jaro_col_name],
      MARGIN = 1,
      FUN = median,
      simplify = TRUE)
  } else if (aggregate_scores == "sum") {
    return_candidates_parents_data[, "jaro_aggregate"] = apply(
      X = return_candidates_parents_data[, jaro_col_name],
      MARGIN = 1,
      FUN = sum,
      simplify = TRUE)
  }

  ## Order by jaro_aggregate
  return_candidates_parents_data = return_candidates_parents_data[order(return_candidates_parents_data[, "jaro_aggregate"],
                                                                        decreasing = TRUE), ]

  ## Return the vector
  return(
    list(
      best_candidate = return_candidates_parents_data[1, ],
      all_candidates = return_candidates_parents_data
    )
  )
}

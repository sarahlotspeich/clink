#' Deterministic parent-child linkage based on exact matches using a single matching key
#'
#' @param baby_to_match data.frame (with one row) for a single baby that includes at least \code{key_baby} as a column.
#' @param parents_to_match data.frame (with multiple rows) for all potential parent matches that includes at least \code{key_parent} as a column.
#' @param key_baby string variable name to match on from \code{baby_to_match}.
#' @param key_parent string variable name to match on from \code{parents_to_match}.
#' @return A copy of \code{baby_to_match} with added columns for the exact-matching parent(s) (if applicable).
#' @export
#' @importFrom dplyr cross_join mutate group_by arrange slice
deterministic_baby_parent_linkage = function(baby_to_match, parents_to_match, key_baby, key_parent) {
  baby_to_match |>
    data.frame() |>
    cross_join(parents_to_match) |>
    filter(.data[[key_baby]] == .data[[key_parent]]) |>
    unique()
}

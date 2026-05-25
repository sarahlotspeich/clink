#' Reshape repeated linking keys from wide to long and back to wide
#'
#' @param data A data.frame containing the repeated columns to reshape.
#' @param id_col Character string. The name of the column that uniquely identifies
#'   each baby, used as the id column in \code{pivot_wider} and the key for
#'   joining the reshaped data back into \code{data} (e.g. \code{"baby_mrn"}).
#' @param col_prefix Character string. The shared prefix of the repeated columns
#'   to unpivot (e.g. \code{"b_pat_relationships_"}, \code{"b_myc_prxy_"}).
#' @param names_pattern Character string. A regex pattern passed to
#'   \code{pivot_longer} to parse column names into \code{.value} and \code{set}
#'   components (e.g. \code{"^b_pat_relationships_name(\\d+)$"}).
#' @param filter_col Character string. The name of the column to filter on after
#'   unpivoting, typically a relationship type column
#'   (e.g. \code{"relation_type"}, \code{"relatn"}). Default is 
#'   \code{filter_col = NULL} (no filtering).
#' @param filter_val Character string. The value to keep in \code{filter_col}
#'   (e.g. \code{"Mother"}, \code{"AH Parent Accessing Child"}). Default is 
#'   \code{filter_val = NULL} (no filtering).
#' @param value_cols Character vector. The name(s) of the column(s) containing
#'   the values of interest after unpivoting (e.g. \code{"name"},
#'   \code{c("email", "home_phone", "add")}).
#' @param output_col_names Character string. The desired name(s) for the output
#'   column in the reshaped data. Used as both the renamed column in the long
#'   format and the prefix for the numbered columns in the wide format
#'   (e.g. \code{"relation_mother_name"} produces \code{relation_mother_name1},
#'   \code{relation_mother_name2}, etc.).
#' @param drop_col_prefix Logical. Whether to drop the original repeated columns
#'   (identified by \code{col_prefix}) from \code{data} before joining the
#'   reshaped columns back in. Default is \code{TRUE}. Set to \code{FALSE} when
#'   making multiple sequential calls with the same \code{col_prefix}, and only
#'   set to \code{TRUE} on the final call.
#'
#' @return A copy of \code{data} with the original repeated columns (identified
#'   by \code{col_prefix}) replaced by numbered output columns named
#'   \code{output_col_name1}, \code{output_col_name2}, etc. Babies with no
#'   matching rows after filtering will have \code{NA} in all output columns.
#'
#' @details
#'   The following steps are applied in order:
#'   \enumerate{
#'     \item Unpivot all columns matching \code{col_prefix} to long format using
#'       \code{pivot_longer}
#'     \item Filter to rows where \code{filter_col} equals \code{filter_val}
#'     \item Rename \code{value_col} to \code{output_col_name} and select
#'       \code{id_col} and \code{output_col_name}
#'     \item Re-widen to one row per baby with numbered output columns
#'     \item Drop original repeated columns from \code{data} and left-join
#'       the reshaped columns back in
#'   }
#'
#' @importFrom dplyr filter rename select distinct group_by mutate left_join join_by
#' @importFrom tidyr pivot_longer pivot_wider
#' @export
reshape_repeated_link_keys = function(data, id_col, col_prefix, names_pattern, filter_col = NULL, filter_val = NULL, value_cols, output_col_names, drop_col_prefix = TRUE) {
  ## Unpivot to one row per baby per relationship
  data_long = data |>
    pivot_longer(
      cols          = starts_with(col_prefix),
      names_to      = c(".value", "set"),
      names_pattern = names_pattern
    )
  
  ## If requested, filter
  if (!is.null(filter_col) & !is.null(filter_val)) {
    data_long = data_long |>
      filter(.data[[filter_col]] == filter_val)
  }
  
  ## Rename value columns and save distinct rows
  data_long = data_long |>
    rename(!!!setNames(value_cols, output_col_names)) |>
    select(all_of(id_col), all_of(output_col_names)) |>
    distinct()
  
  ## Re-widen to one row per baby with numbered output columns
  data_wide = data_long |>
    group_by(.data[[id_col]]) |>
    mutate(match_num = 1:n()) |>
    pivot_wider(
      id_cols      = all_of(id_col),
      values_from  = all_of(output_col_names),
      names_from   = match_num,
      names_sep    = "_",
      names_glue   = "{.value}_{match_num}"
    )

  ## If requested, drop original columns 
  if (drop_col_prefix) {
    data = data |> 
      select(-starts_with(col_prefix))
  }
  ## Then join reshaped columns back in and return
  data |>
    left_join(y = data_wide, by = join_by(!!id_col))
}
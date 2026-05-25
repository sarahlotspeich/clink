#' Clean and standardize a name string for matching
#'
#' @param name_text A character vector of name(s) to clean.
#'
#' @return A character vector of the same length as \code{name_text} with all
#'   letters uppercased, spaces removed, and punctuation removed.
#'
#' @details
#'   The following transformations are applied in order:
#'   \enumerate{
#'     \item Convert to uppercase via \code{toupper()}
#'     \item Remove all spaces
#'     \item Remove all punctuation (e.g. trailing periods, hyphens)
#'   }
#'
#' @examples
#' clean_name("Mary-Jane Smith")  # Returns "MARYJANESMITH"
#' clean_name("O'Brien.")         # Returns "OBRIEN"
#'
#' @importFrom stringr str_replace_all str_remove_all
#' @export
name_clean_before_linkage = function(name_text) {
  ## Make all caps
  name_text = toupper(name_text)
  ## Remove all spaces
  name_text = str_replace_all(string = name_text,
                              pattern = " ",
                              repl = "")
  ## Remove punctuation (some names had a period at the end, potentially inconsistent hyphenation)
  name_text = str_remove_all(string = name_text,
                             pattern = "[[:punct:]]")
  ## Return cleaned name
  return(name_text)
}

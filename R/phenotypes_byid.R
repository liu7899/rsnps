#' Get all known variations and all users sharing that phenotype for 
#' one phenotype(-ID).
#'
#' @export
#' @param phenotypeid ID of openSNP phenotype.
#' @param return_ Return data.frame (TRUE) or not (FALSE) - default = FALSE.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}.
#' @return List of description of phenotype, list of known variants, or 
#' data.frame of variants for each user with that phenotype.
#'
#' @examples \dontrun{
#' phenotypes_byid(phenotypeid=12, return_ = 'desc')
#' phenotypes_byid(phenotypeid=12, return_ = 'knownvars')
#' phenotypes_byid(phenotypeid=12, return_ = 'users')
#'
#' # pass on curl options
#' library("httr")
#' phenotypes_byid(phenotypeid=12, return_ = 'desc', 
#'   config=c(verbose(), timeout(1)))
#' phenotypes_byid(phenotypeid=12, return_ = 'desc', config=verbose())
#' }

phenotypes_byid <- function(phenotypeid = NA, 
                    return_ = c('description','knownvars','users'), ...) {
  
  url2 <- paste0(paste0(osnp_base(), "phenotypes/json/variations/"), 
                 phenotypeid, '.json')
  message(url2)
  res <- GET(url2, ...)
  stop_for_status(res)
  out <- jsonlite::fromJSON(cuf8(res), FALSE)

  return_2 <- match.arg(return_, c('description','knownvars','users'), FALSE)

  if (return_2 == 'description') {
    out[c('id','characteristic','description')]
  } else if (return_2 == 'knownvars') {
      out[c('known_variations')]
    } else {
      ldply(out$users, data.frame, stringsAsFactors = FALSE)
    }
}

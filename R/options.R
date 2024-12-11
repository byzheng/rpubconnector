# * Author:    Bangyou Zheng (Bangyou.Zheng@csiro.au)
# * Created:   03:40 PM Saturday, 09 June 2018
# * Copyright: AS IS



# Variable, global to package's namespace.
# This function is not exported to user space and does not need to be documented.
PUB_OPTIONS <- settings::options_manager(
    host = "http://127.0.0.1:8080/"
)

rtiddlywiki::tw_options(host = PUB_OPTIONS()$host)

#' Set or get options for my package
#'
#' @param ... Option names to retrieve option values or \code{[key]=[value]} pairs to set options.
#'
#' @section Supported options:
#' The following options are supported
#'  host: host of tiddlywiki
#'  output: output for intermediate files
#'  author_max: Maximum number of authors/colleagues to download
#'  file_expired: days to intermediate files expired
#'  file_remove_max: maximum number of intermediate file to remove
#'  latest_literature: tiddler name for latest literature
#'
#' @return the default and modified options.
#' @export
#' @examples
#' pub_options(host = "http://127.0.0.1:8080/")
pub_options <- function(...){
    # protect against the use of reserved words.
    settings::stop_if_reserved(...)
    PUB_OPTIONS(...)
    rtiddlywiki::tw_options(host = PUB_OPTIONS()$host)
    PUB_OPTIONS()
}

#' Reset global options for pkg
#'
#' @return the default options
#' @export
#' @examples
#' pub_reset()
pub_reset <- function() {
    settings::reset(PUB_OPTIONS)
}

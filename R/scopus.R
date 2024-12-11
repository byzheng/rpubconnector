#' Get eid from Scopus
#'
#' @return No return values
#' @export
scopus_eid <- function() {

    dois <- get_dois(filter = "[tag[bibtex-entry]!hasp[draft.of]!is[system]has[bibtex-doi]!tag[Preprint]!tag[Accepted Article]!has:field[scopus-eid]!has:field[eid-ignore]]")


    max_request <- 4000
    request_num <- 0

    i <- 1
    for (i in seq(along = dois[[1]])) {
        tryCatch({

            message("Get EID from scopus for doi ", dois$doi[i], " with ", dois$title[i])
            works <- rscopus::embase_retrieval(id = dois$doi[i], identifier = "doi", verbose = FALSE)

            if (length(works$content) == 0 || httr::status_code(works$get_statement) == 404) {
                eid <- ""
            } else {
                eid <- works$content$`abstracts-retrieval-response`$coredata$eid
            }
            message("EID for ", dois$title[i], " is ", eid)
            rtiddlywiki::put_tiddler(dois$title[i], fields = list(`scopus-eid` = eid))
        }, error = function(e) {
            stop(e)
        })
    }
    return(invisible())
}

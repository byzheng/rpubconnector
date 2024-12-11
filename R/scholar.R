
#' Get ids from Google Scholar
#'
#' @return No return
#' @export
scholar_ids <- function() {
    all_dois <- get_dois(filter = "[tag[bibtex-entry]!hasp[draft.of]!is[system]has[bibtex-doi]!tag[Preprint]!tag[Accepted Article]!has:field[scholar-cid]]")


    daily_maximum <- 20
    # only process missing dois for crossref
    dois <- all_dois
    if (is.null(all_dois) || nrow(dois) == 0) {
        return(invisible())
    }
    dois <- dois |>
        dplyr::slice(seq_len(min(daily_maximum, dplyr::n())))
    i <- 1
    for (i in seq(along = dois[[1]])) {
        message("Get information from google scholar for doi ", dois$doi[i], " with ", dois$title[i])
        url <- "https://scholar.google.com/scholar"
        info <- httr2::request(url) |>
            httr2::req_url_query(q = dois$doi[i]) |>
            httr2::req_user_agent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.128 Safari/537.36') |>
            httr2::req_perform()
        resp <- httr2::resp_body_html(info)

        cid <- ""
        did <- ""
        aid <- ""
        cites <- ""
        item <- xml2::xml_find_first(resp, "//div[contains(@class,'gs_r') and contains(@class, 'gs_or')  and contains(@class, 'gs_scl')]")
        #xml2::write_html(resp, "a.html")
        if (length(item) > 0) {
            cid <- xml2::xml_attr(item, "data-cid")
            did <- xml2::xml_attr(item, "data-did")
            aid <- xml2::xml_attr(item, "data-aid")
            links <- xml2::xml_find_all(resp, "//div[contains(@class,'gs_fl')]/a")
            j <- 1
            for (j in seq(along = links)) {
                href <- xml2::xml_attr(links[j], "href")
                if (length(grep("cites", href)) > 0) {
                    href <- httr2::url_parse(href)
                    cites <- href$query$cites
                    break
                }
            }
        }
        message("CID for ", dois$title[i], " is ", cid)
        message("CITES for ", dois$title[i], " is ", cites)
        rtiddlywiki::put_tiddler(dois$title[i], fields = list(`scholar-cid` = cid,
                                                              `scholar-cites` = cites))

        if (nrow(dois) > 1) {
            Sys.sleep(5 + stats::runif(1) * 5)
        }
    }
    return(invisible())
}

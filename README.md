
> [!CAUTION]
> This package will modify in Tiddlywiki. Use it with caution. 
> Create a backup and test it before using.

# rpubconnector

R package `rpubconnector` is to retrieve information from [Scopus](https://scopus.com) and 
[Google Scholar](https://scholar.google.com/) into  [Tiddlywiki](https://tiddlywiki.com/).


## Installation

Install the developing version from [Github](https://github.com/byzheng/rpubconnector).

```r
remotes::install_github('byzheng/rpubconnector')
```


## Data structure

Tiddlers with tag `bibtex-entry` will be added the following fields

* `scopus-eid` for unique id in Scopus.
* `scholar-cid` for unique id in the search list of Scholar.  
* `scholar-cites` for unique id in the author profile of Scholar which depends on whether there is a citation.



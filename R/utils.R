get_tablename <- function(x) {
    UseMethod("get_tablename")
}

get_tablename.default <- function(x) {
    x
}

get_tablename.character <- function(x) {
    x
}

get_tablename.aws_dynamodb_table <- function(x) {
    x$TableName
}


map_attributes <- function(item) {
    item_formatted <- list()
    for (i in seq_along(item)) {
        if (is.null(item[[i]])) {
            item_formatted[[i]] <- list(NULL = TRUE)
        } else if (is.list(item[[i]])) {
            if (is.null(names(item[[i]])) || any(names(item[[i]]) %in% "")) {
                item_formatted[[i]] <- list(L = map_attributes(unname(item[[i]])))
            } else {
                item_formatted[[i]] <- list(M = map_attributes(item[[i]]))
            }
        } else if (is.raw(item[[i]])) {
            item_formatted[[i]] <- list(B = jsonlite::base64_enc(item[[i]]))
        } else if (is.logical(item[[i]])) {
            item_formatted[[i]] <- list(BOOL = item[[i]])
        } else if (is.numeric(item[[i]])) {
            if (length(item[[i]]) == 1L) {
                item_formatted[[i]] <- list(N = item[[i]])
            } else {
                item_formatted[[i]] <- list(NS = as.numeric(na.omit(item[[i]])))
            }
        } else {
            if (length(item[[i]]) == 1L) {
                item_formatted[[i]] <- list(S = as.character(item[[i]]))
            } else {
                item_formatted[[i]] <- list(SS = as.character(na.omit(item[[i]])))
            }
        }
    }
    names(item_formatted) <- names(item)
    return(item_formatted)
}

post_process <- function(l) {
    lapply(l, format_element)
}

format_element <- function(x) {
    stopifnot(length(x) == 1)
    fun <- switch(
        names(x),
        BOOL = as.logical,
        L = post_process,
        M = function(l) post_process(l),
        N = as.numeric,
        NS = as.numeric,
        "NULL" = function(l) NULL,
        S = as.character,
        SS = as.character,
        stop("Incorrect type: ", names(x))
    )
    fun(x[[1]])
}
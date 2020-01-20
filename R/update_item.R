#' @title Update an item
#' @description Update an item into a Dynamo DB database
#' @param table A character string specifying the table name, or an object of class \dQuote{aws_dynamodb_table}.
#' @param key  If the table only has a primary key, this should specify the primary key attribute name and value for the desired item. If a composite primary key is used, then both attribute names and values must be specified.
#' @param item A list of key-value pairs.
#' @param action Action to perform on the key-value pairs. This should be a character vector of length one or the length of `item`.
#' @param condition Optionally, a \dQuote{ConditionExpression} that determines whether the item is added. This can prevent overwriting. See \href{https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ConditionExpressions.html}{User Guide: Condition Expressions}.
#' @param return_value A character string specifying whether to return previous values of the item.
#' @param \dots Additional arguments passed to \code{\link{dynamoHTTP}}.
#' @return A list.
#' @references
#'   \href{https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_UpdateItem.html}{API Guide: UpdateItem}
#' @examples
#' \dontrun{
#'   tab <- create_table(
#'     table = "Music",
#'     attributes = list(Artist = "S"),
#'     primary_key = "Artist"
#'   )
#' 
#'   # put item
#'   put_item("Music", list(Artist = "No One You Know", SongTitle = "Call Me Yesterday"))
#'   
#'   # get item
#'   get_item("Music", list(Artist = "No One You Know"))
#'   
#'   # update item
#'   update_item("Music", list(Artist = "No One You Know"), list(SongTitle = "Call Me Today"))
#'   
#'   # get item
#'   get_item("Music", list(Artist = "No One You Know"))

#'   # cleanup
#'   delete_table(tab)
#' }
#' @export
update_item <-
  function(
    table,
    key,
    item,
    action = "PUT",
    return_value = c("NONE", "ALL_OLD"),
    ...
  ) {
    # format key
    key_formatted <- map_attributes(key)
    
    # format item
    if (length(action) == 1) action <- rep(action, length(item))
    stopifnot(length(action) == length(item))
    item_map <- map_attributes(item)
    item_formatted <- lapply(seq_along(item), function(i) {
      list(Action = action[i], Value = item_map[[i]])
    })
    names(item_formatted) <- names(item_map)
    
    return_value <- match.arg(return_value)
    bod <- list(TableName = get_tablename(table),
                ReturnValues = return_value,
                AttributeUpdates = item_formatted,
                Key = key_formatted)
    out <- dynamoHTTP(verb = "POST", body = bod, target = "DynamoDB_20120810.UpdateItem", ...)
    if (return_value == "NONE") {
      return(NULL)
    } else {
      return(out)
    }
  }
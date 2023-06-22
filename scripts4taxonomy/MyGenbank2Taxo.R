MyGenbank2Taxo <- function(genbankIDList, max_retries=5){
  # Initialize variables
  retry_count <- 0
  max_retries <- max_retries
  failed_queries <- vector("character", length(genbankIDList))
  result <- vector("list", length(genbankIDList))
  Print("Querring NCBI Started")
  for (i in seq_along(genbankIDList)) {
    # Check if the query failed previously
    if (i > retry_count) {
      # Retry the query
      result[[i]] <- tryCatch(
        classification(genbank2uid(id = genbankIDList[i]), db = "ncbi"),
        error = function(e) {
          message(paste("Query", genbankIDList[i], "failed. Retrying..."))
          failed_queries[i] <<- TRUE  # Mark the query as failed
          return(NULL)  # Return NULL for failed queries
        }
      )
      
      # Check if the query was successful
      if (!is.null(result[[i]])) {
        # Reset the retry count
        retry_count <- 0
      } else {
        # Increment the retry count
        retry_count <- retry_count + 1
        
        # Check if the maximum number of retries has been reached
        if (retry_count >= max_retries) {
          message(paste("Maximum number of retries reached for query", genbankIDList[i]))
          break  # Exit the loop if maximum retries reached
        }
        
        # Skip to the next iteration
        next
      }
    }
    # If the loop reaches this point, it means the iteration was skipped due to a failed query
  }
  Print("Querring NCBI Done")  
  return(result)
}

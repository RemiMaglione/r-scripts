MyGenbank2Taxo <- function(genbankIDList, max_retries=5){
  require('taxize')
  # Initialize variables
  max_retries <- max_retries
  failed_queries <- vector("character", length(genbankIDList))
  result <- list()  # Initialize an empty list
  print("Querring NCBI Started")
  for (i in seq_along(genbankIDList)) {
    
    retry_count <- 0 #initiate retry count
    
    while (retry_count <= max_retries) {
      query_result <- tryCatch(
        classification(genbank2uid(id = genbankIDList[i]), db = "ncbi"),
        error = function(e) {
          message(paste("Query", genbankIDList[i], "failed. Retrying..."))
          return(NULL)  # Return NULL for failed queries
        }
      )
      
      # Check if the query was successful
      if (!is.null(query_result)) {
        # Process the successful result
        result[[genbankIDList[i]]] <- query_result[[1]]
        
        # Reset the failed query flag
        failed_queries[i] <- FALSE
        
        break  # Exit the retry loop if successful
      } else {
        # Increment the retry count
        retry_count <- retry_count + 1
      }
    }
    
    # Check if the maximum number of retries has been reached without success
    if (retry_count > max_retries) {
      message(paste("Maximum number of retries reached for query", genbankIDList[i]))
    }
    # If the loop reaches this point, it means the iteration was skipped due to a failed query
  }
  print("Querring NCBI Done")  
  return(result)
}

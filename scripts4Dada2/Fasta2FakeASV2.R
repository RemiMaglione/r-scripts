fasta2FakeASV2 <- function(MyFastaPath){
  require(Biostrings)
  MyFasta <- readDNAStringSet(filepath = MyFastaPath)

  # Create an empty data frame
  MyFakeASV <- data.frame(row.names = "fake", stringsAsFactors = FALSE)

  # Iterate over the sequences and add columns with DNA sequences as column names
  for (i in seq_along(MyFasta)) {
    col_name <- as.character(MyFasta[i])
    MyFakeASV[[col_name]] <- 0
}

# Return the Fake ASV
return(MyFakeASV)
}

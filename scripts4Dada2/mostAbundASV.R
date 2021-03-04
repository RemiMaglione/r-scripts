mostAbundASV <- function(otu_comm, topASV = 1, ASVseqColName = "MostAbundASVseq") { 
  mostAbundASV.sample <- data.frame("MostAbundASVseq"=character()) #create am empty data frame
  for (i in 1:nrow(otu_comm)) { #iterate on community_taxo matrix rows (=sample)
    tmp.row <- rownames(otu_comm[i,, drop=FALSE]) # temporary store the row names (=sample name)
    tmp.mostAbundASV <- rownames(data.frame(otu_comm[i, ])[order(-data.frame(otu_comm[i, ])),,drop=FALSE])[topASV]
    # Take only the 1rst ([1] at the end), most abundant (order(-...)) ASV (rowname) on the selected sample (i)
    # From the row of the comm taxo matrix (data.frame(otus_comm[i,])[..,,drop=FALSE"important to keep the row name during the process"]). 
    tmp.mostASVAbund <- (data.frame(otu_comm[i, ])[order(-data.frame(otu_comm[i, ])),,drop=FALSE])[topASV,]
    mostAbundASV.tmp <- data.frame("MostAbundASV"=tmp.mostAbundASV, "Abund"=tmp.mostASVAbund)
    rownames(mostAbundASV.tmp) <- tmp.row
    mostAbundASV.sample <- rbind(mostAbundASV.sample, mostAbundASV.tmp) #use rbind to add the last row to the final data frame
  }
  colnames(mostAbundASV.sample) <- c(ASVseqColName, "Abund")
  return(mostAbundASV.sample) 
}

  #################################################################
  # Extract top ASV (default top 20) and return a phyloseq object #
  #       Developped By Rémi Maglione For Kembel Lab              #
  #################################################################
topASV <- function(comm, tax, meta, top=20){
  ps <-phyloseq(otu_table(comm, taxa_are_rows=FALSE),
                tax_table(tax),
                sample_data(meta))
  top.names <- names(sort(taxa_sums(ps), decreasing=TRUE))[1:top] 
  ps.top <- prune_taxa(top.names, ps) 
  ps.top <- merge_phyloseq(ps.top, sample_data(meta))
  return(ps.top)
}

asv2LEfSe2 <- function(ps.data, subject=NA, class=NA, subclass=NA){
  ################################################################
  # Convert ASV embeded in phyloseq object to LEfSe table format #
  #       Developped By Rémi Maglione For Kembel Lab             #
  # Thanks To Alexandre Naud For it's improve in code efficiency #
  ################################################################
  # Create Tax vector
  tax_lefse <- apply(ps.data@tax_table@.Data, 1, function(x) paste(c(x), collapse = "|"))
  tax_lefse <- tax_lefse[order(names(tax_lefse))]
  
  # Create asv table
  asv_table <- ps.data@otu_table@.Data
  asv_table <- asv_table[,order(colnames(asv_table))]
  
  # Join asv and tax
  tax_asv <- t(rbind(tax_lefse, asv_table))
  row.names(tax_asv) <- tax_asv[,1]
  tax_asv <- tax_asv[,-1]
  
  # Extract meta data
  ifelse(!is.na(subclass), 
         yes = meta <- t(ps.data@sam_data[,c(subject, class, subclass)]),
         no = meta <- t(ps.data@sam_data[,c(subject, class)]))
  
  # Join meta and tax_asv
  final_table <- rbind(meta, tax_asv)
  return(final_table)
  
}

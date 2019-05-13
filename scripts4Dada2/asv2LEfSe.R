asv2LEfSe <- function(ps.data){
  ################################################################
  # Convert ASV embeded in phyloseq object to LEfSe table format #
  #       Developped By Rémi Maglione For Kembel Lab             #
  # Thanks to Alexandre Naud for his advice in code efficiency   #
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
  meta <- t(ps.data@sam_data[,c("ech", "traitement")])
  
  # Join meta and tax_asv
  final_table <- rbind(meta, tax_asv)
  return(final_table)

}

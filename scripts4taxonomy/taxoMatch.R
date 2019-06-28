#####################################################
#   Find match between LEfSe and a taxonomic table  #
#    Add a column to the taxonomic table with :     #
#        'Yes'/match or 'No'/no-match               #
#    Developped by Rémi Maglione For kembel Lab     #
#####################################################
taxoMatch <-  function(mock.table=mock.table, lda.table=lda.table, colname.match = "match"){
  for (i in 1:length(rownames(mock.table))) {
    ifelse(test = mock.table[i, "Genus"]%in%lda.table$Genus,
           yes = ifelse(
             test = !is.na(unlist(strsplit(mock.table$species[i],"/"))),
             yes = ifelse(
               test = unlist(strsplit(mock.table$species[i],"/"))%in%unlist(strsplit(lda.table$species[which(lda.table$Genus==mock.table$Genus[i])],"_")),
               yes = mock.table[i, colname.match] <- "Oui",
               no = mock.table[i, colname.match] <- "Non"),
             
             no = mock.table[i, colname.match] <- "Non"),
           
           no = mock.table[i, colname.match] <- "Non")
    }
  return(mock.table)
}

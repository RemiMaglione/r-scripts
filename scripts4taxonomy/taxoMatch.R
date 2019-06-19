taxoMatch <-  function(mock.table=mock.table, lda.table=lda.table, colname.match = "match"){
  for (i in 1:length(rownames(mock.table))) {
    ifelse(test = mock.table[i, "Genus"]%in%lda.table$Genus,
           yes = ifelse(
             test = !is.na(unlist(strsplit(mock.table$species[i],"/"))),
             yes = ifelse(
               test = unlist(strsplit(mock.table$species[i],"/"))%in%unlist(strsplit(lda.table$species[which(lda.table$Genus==mock.table$Genus[i])],"_")),
               yes = mock.table[i, colname.match] <- "Yes",
               no = mock.table[i, colname.match] <- "No"),
             
             no = mock.table[i, colname.match] <- "No"),
           
           no = mock.table[i, colname.match] <- "No")
    }
}

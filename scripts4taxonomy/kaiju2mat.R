###########################################################
# R script to convert 'kaiju-addTaxonNames' output to a proper R matrix where only remain the sequence name and the full taxonomic path in individual column
# 'kaiju-addTaxonNames' output has to be yield by the following cmd : 
# kaiju-addTaxonNames -t nodes.dmp -n names.dmp -i kaiju.out -o kaiju.names.out -r superkingdom,phylum,class,order,family,genus,species
# Working r input: table.taxo <- read.table(file = "kaiju.names.out", sep = "\t", fill = TRUE, row.names = NULL, header = FALSE, quote = "") 
###########Codded by Rémi Maglione for Kembel Lab###########

require(parallel)
cores <- detectCores()

kaiju2mat <- function(table.taxo) {
  mat <- matrix(unlist(mclapply(1:nrow(table.taxo), FUN = function(i) {
    ifelse(!table.taxo[i, 4]=="",
           yes = {x.tmp <- unlist(strsplit(x = as.character(table.taxo[i, 4]), split = ";"))
           length(x.tmp) <- 7
           return(x.tmp)
           },
           no = {x.tmp <- table.taxo[i, 4]
           length(x.tmp) <- 7
           return(x.tmp)
           })
    }, mc.cores = cores-1)), ncol = 7, byrow = TRUE)
  mat <- cbind(as.matrix(table.taxo[,2]), mat)
  colnames(mat) <- c("seqname", "superkingdom","phylum","class","order","family","genus","species")
  return(mat)
  }

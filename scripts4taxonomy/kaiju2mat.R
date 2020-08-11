###########################################################
# R script to convert 'kaiju-addTaxonNames' output to a proper R matrix where only remain the sequence name and the full taxonomic path in individual column
# 'kaiju-addTaxonNames' output has to be yield by the following cmd : 
# kaiju-addTaxonNames -t nodes.dmp -n names.dmp -i kaiju.out -o kaiju.names.out -r superkingdom,phylum,class,order,family,genus,species
# Working r input: table.taxo <- read.table(file = "kaiju.names.out", sep = "\t", fill = TRUE, row.names = NULL, header = FALSE, quote = "") 
###########Codded by Rémi Maglione for Kembel Lab###########

#Parallel package install control
if (!require("parallel")) install.packages("parallel")

#Function
kaiju2mat <- function(table.taxo, parallel=TRUE) {
  require(parallel)
  ifelse(test = isTRUE(parallel),
         yes = {
           cores <- detectCores()
           cores <- cores-1
         },
         no = cores <- parallel)
  
  mat <- matrix(unlist(mclapply(1:nrow(table.taxo), FUN = function(i) {
    ifelse(!table.taxo[i, 4]=="",
           yes = {x.tmp <- unlist(strsplit(x = as.character(table.taxo[i, 4]), split = ";"))
           length(x.tmp) <- 7
           return(x.tmp)
           },
           no = {x.tmp <- NA
           length(x.tmp) <- 7
           return(x.tmp)
           })
  }, mc.cores = cores)), ncol = 7, byrow = TRUE)
  mat <- cbind(as.matrix(table.taxo[,2]), mat)
  colnames(mat) <- c("gene_callers_id","t_domain","t_phylum","t_class","t_order","t_family","t_genus","t_species")
  return(mat)
}

#Main USAGE
#table.taxo <- read.table(file = "kaiju.names.out", sep = "\t", fill = TRUE, row.names = NULL, header = FALSE, quote = "") 
#table.taxo.mat <- kaiju2mat(table.taxo)

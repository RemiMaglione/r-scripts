#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
parallel=TRUE

#Input control
if (length(args)==0) {
  stop("At least one argument must be supplied (input kaiju file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "kaiju2Anvio-fixed.names"
} else if (length(args)==3) {
  parallel = args[3]
}

#Parallel package install control
if (!require("parallel")) install.packages("parallel")

kaiju2mat <- function(kaiju.names, parallel) {
  require(parallel)
  ifelse(test = isTRUE(parallel),
         yes = {
           cores <- detectCores()
           cores <- cores-1
         },
         no = cores <- parallel)
  
  mat <- matrix(unlist(mclapply(1:nrow(kaiju.names), FUN = function(i) {
    ifelse(!kaiju.names[i, 4]=="",
           yes = {x.tmp <- unlist(strsplit(x = as.character(kaiju.names[i, 4]), split = ";"))
           length(x.tmp) <- 7
           return(x.tmp)
           },
           no = {x.tmp <- NA
           length(x.tmp) <- 7
           return(x.tmp)
           })
  }, mc.cores = cores)), ncol = 7, byrow = TRUE)
  mat <- cbind(as.matrix(kaiju.names[,2]), mat)
  colnames(mat) <- c("gene_callers_id","t_domain","t_phylum","t_class","t_order","t_family","t_genus","t_species")
  return(mat)
}

kaiju.names <- read.table(file = args[1], sep = "\t", fill = TRUE, row.names = NULL, header = FALSE, quote = "")
kaijumat<-kaiju2mat(kaiju.names=kaiju.names, parallel = parallel)
write.table(kaijumat, file = args[2], quote = FALSE, col.names = TRUE, row.names = FALSE)


strain2sample <- function(strain.ps=NA, sample.ps=NA, strain=NA, rank=NA, sampleColumn=NA){
  strain.row <- which(strain.ps@tax_table@.Data[,sampleColumn]%in%strain)
  strain.seq <- rownames(strain.ps@tax_table@.Data[strain.row,])
  strain.ps.sub <- strain.ps@otu_table@.Data[,strain.seq]
  strain.ps.sub <- strain.ps.sub[which(apply(strain.ps.sub, 1, FUN=function(x) sum(x)>0)),]
  topASV <- apply(strain.ps.sub, 1, FUN=function(x) names(x[which(x==max(x))])[1])
  topASV<- cbind(seq=topASV, 
                 strain.abund=apply(strain.ps.sub, 1, FUN=function(x) max(x)), 
                 max.abund=apply(strain.ps@otu_table@.Data[rownames(strain.ps.sub),], 1, FUN=function(x) max(x)))
  return(topASV)
}

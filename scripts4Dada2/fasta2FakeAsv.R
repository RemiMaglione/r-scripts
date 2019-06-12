# Remove Seq name without sequence
fasta=NA
j=1
for (i in 1:length(rownames(Myfasta))) {
  ifelse(substr(Myfasta[i+1,1], 1, 1)==">", 
         NA,
         {fasta[j]<-Myfasta[i,1]
         fasta[j+1]<-Myfasta[i+1,1]
         j=j+2
         })
}
fasta<-data.frame(fasta)
fasta$fasta <- as.character(fasta$fasta)

# Split Sequence name and sequence
### Sequence under 50 nucleotids will be output in another data
j=1
k=1
sample.less50nts=NA
seq.less50nts=NA
sample=NA
seq=NA

for (i in 1:length(rownames(fasta))) {

  ifelse(substr(fasta[i,1], 1, 1)==">", 
         yes = ifelse(nchar(fasta[i+1,1])<50,
                      yes = {
                        sample.less50nts[k] <- fasta[i,1]
                        seq.less50nts[k] <- fasta[i+1,1]
                        k=k+1},
                      no = {
                        sample[j]<-fasta[i,1]
                        seq[j]<-fasta[i+1,1]
                        j=j+1}),
         no = NA)
}

# Recover data with sample names and their related sequence (future dev)
fasta.key <- data.frame(sample=sample, seq=seq)
fasta.less50nts.key <- data.frame(sample=sample.less50nts, seq=seq.less50nts)

# Build the fake seq.tab (ASV)
seq.tab.fake <- t(data.frame(matrix(0, nrow = length(seq[!duplicated(seq)]), ncol = 1), row.names = seq[!duplicated(seq)]))
rownames(seq.tab.fake) <- "fake"

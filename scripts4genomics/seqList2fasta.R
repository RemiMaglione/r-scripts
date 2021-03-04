###############################################
#   Convert sequences list to .fasta format   #
# Developped by Rémi Maglione For kembel Lab  #
###############################################
seqList2fasta <- function(seq, file="ASV.fasta", write2file=TRUE, repName=FALSE) { 
  fasta<-NA #create an empty vector
  j=1 #1rst line to append seq in the vetor
  ifelse(isTRUE(repName),
         yes = {for (i in 1:length(seq)) { #iterate on seq
           #As fasta standard format is split in 3 lines per sequence like "names, seq, blank line": 
           fasta[j]<-paste0(">SV",i, sep="") #add SV+i as seq name
           fasta[j+1]<-paste(seq[i]) #add seq
           fasta[j+2]<-paste("") #add blank line
           j=(i*3)+1 #append 1rst line position for the next sequence)
         }
           if(isTRUE(write2file)){ #control if fasta vector have to be write (DEFAULT: TRUE)
             write.table(data.frame(fasta, stringsAsFactors=FALSE), #write the vector as a dataframe
                         file = file, #In the file and directory chosen by the user (Default: ASV.fasta)
                         col.names = FALSE, #no colnames
                         row.names = FALSE, #no rownames
                         quote = FALSE) #no quote for the character
           }
           return(data.frame(fasta, stringsAsFactors=FALSE))  #return fasta vector as a dataframe
         },
         no = {for (i in 1:length(seq)) { #iterate on seq
           #As fasta standard format is split in 3 lines per sequence like "names, seq, blank line": 
           fasta[j]<-paste(">",seq[i], sep="") #add seq as seq name
           fasta[j+1]<-paste(seq[i]) #add seq
           fasta[j+2]<-paste("") #add blank line
           j=(i*3)+1 #append 1rst line position for the next sequence)
         }
           if(isTRUE(write2file)){ #control if fasta vector have to be write (DEFAULT: TRUE)
             write.table(data.frame(fasta, stringsAsFactors=FALSE), #write the vector as a dataframe
                         file = file, #In the file and directory chosen by the user (Default: ASV.fasta)
                         col.names = FALSE, #no colnames
                         row.names = FALSE, #no rownames
                         quote = FALSE) #no quote for the character
           }
           return(data.frame(fasta, stringsAsFactors=FALSE))  #return fasta vector as a dataframe
         })
}

################################################
###           Qual VS MaxEE Plot             ###
### Scripted by Remi Maglione for Kembel Lab ###
################################################

#### Extract qual with FastQC and sed
#fastqc --nogroup (requiered) yourFastqFile_R1.fastq yourFastqFile_R2.fastq
#From the fastQC output file:
#sed -n '/>>Per\sbase\ssequence\squality/,/>>END_MODULE/p' fastqc_data.txt  | sed '1d;$d' > fastq.qual.csv

###For R analysis you will need to load the multiplot.R function : 
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/

### Function
qualMaxEEplot <- function(fastq.r1, fastq.r2, name1= "Fastq_R1", name2="Fastq_R2") {
  ### Loading dependenies
  require(ggplot2)
  ### Definning function  
  fastqTmp <- function(fastq) {  
    fastq.tmp <- rbind(data.frame(R=fastq$X.Base, 
                                  Q=fastq$Mean, S=c("Mean"), 
                                  E=10^(-fastq$Mean/10), 
                                  A=Reduce('+', 10^(-fastq$Mean/10), accumulate = TRUE)),
                       data.frame(R=fastq$X.Base, 
                                  Q=fastq$Median, 
                                  S=c("Median"), 
                                  E=10^(-fastq$Median/10), 
                                  A=Reduce('+', 10^(-fastq$Median/10), accumulate = TRUE)),
                       data.frame(R=fastq$X.Base, 
                                  Q=fastq$Lower.Quartile, 
                                  S=c("Lower.Quartile"), 
                                  E=10^(-fastq$Lower.Quartile/10), 
                                  A=Reduce('+', 10^(-fastq$Lower.Quartile/10), accumulate = TRUE)),
                       data.frame(R=fastq$X.Base, 
                                  Q=fastq$Upper.Quartile, 
                                  S=c("Upper.Quartile"), 
                                  E=10^(-fastq$Upper.Quartile/10), 
                                  A=Reduce('+', 10^(-fastq$Upper.Quartile/10), accumulate = TRUE)),
                       data.frame(R=fastq$X.Base, 
                                  Q=fastq$X10th.Percentile, 
                                  S=c("X10th.Percentile"), 
                                  E=10^(-fastq$X10th.Percentile/10), 
                                  A=Reduce('+', 10^(-fastq$X10th.Percentile/10), accumulate = TRUE)),
                       data.frame(R=fastq$X.Base, 
                                  Q=fastq$X90th.Percentile, 
                                  S=c("X90th.Percentile"), 
                                  E=10^(-fastq$X90th.Percentile/10), 
                                  A=Reduce('+', 10^(-fastq$X90th.Percentile/10), accumulate = TRUE)))
    return(fastq.tmp)
  }
  
  qualPlot <- function(df.tmp) {
    p_r <- ggplot(df.tmp, aes(color=S)) + 
      geom_point(aes(x=R, y=Q), size=1) + 
      labs(x="Reads position", y="Reads Quality")
    return (p_r)
  }
  
  maxEEplot <- function(df.tmp) {
    q_r <- ggplot(df.tmp, aes(color=S)) + 
      geom_point(aes(x=R, y=log10(A)), size=1) + 
      geom_hline(yintercept=log10(2), color = "red") + 
      geom_hline(yintercept=log10(3), color = "red") + 
      geom_hline(yintercept=log10(5), color = "red") + 
      geom_hline(yintercept=log10(7), color = "red") +
      geom_text(label="MaxEE=2", aes(x=0, y=log10(2), hjust = 0, vjust=0), color="red") + 
      geom_text(label="MaxEE=3", aes(x=0, y=log10(3), hjust = 0, vjust=0), color="red") + 
      geom_text(label="MaxEE=5", aes(x=0, y=log10(5), hjust = 0, vjust=0), color="red") + 
      geom_text(label="MaxEE=7", aes(x=0, y=log10(7), hjust = 0, vjust=0), color="red") +
      labs(x="Reads position", y="EE = sum(10^(-Q/10)) log10") +
      coord_cartesian(ylim = c(log10(min(df.tmp$A)), log10(max(df.tmp$A))))
    return (q_r)
  }
  
  ### MAIN  
  p_r1 <- qualPlot(df.tmp = fastqTmp(fastq.r1)) + 
    ggtitle(name1) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  p_r2 <- qualPlot(df.tmp = fastqTmp(fastq.r2)) + ggtitle(name2) + 
    ggtitle(name2) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  q_r1 <- maxEEplot(df.tmp = fastqTmp(fastq.r1))
  q_r2 <- maxEEplot(df.tmp = fastqTmp(fastq.r2))
  
  return(multiplot(p_r1, q_r1, p_r2, q_r2, cols = 2))
}

### Example of usage

###Run1_2016
fastq.r1 <- read.csv(file="/data/users/remi/miSeq/run1/adaptor_cleaned/fastqc/2016_run1_AC_R1_fastqc/fastq.qual.csv", sep = "\t", header = TRUE)
fastq.r2 <- read.csv(file="/data/users/remi/miSeq/run1/adaptor_cleaned/fastqc/2016_run1_AC_R2_fastqc/fastq.qual.csv", sep = "\t", header = TRUE)

qualMaxEEplot(fastq.r1 = fastq.r1, fastq.r2 = fastq.r2)

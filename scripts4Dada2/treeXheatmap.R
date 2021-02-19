treeXheatmap <-function(dataF, tree) {
  d = fortify(tree)
  d = subset(d, isTip)
  dataF <- dataF[with(d, label[order(y, decreasing = FALSE)]),]
  dataF$tip.label <- NA2taxa(dat.taxo = dataF, oneNa = T)
  t.ggtree <- ggtree(tree, branch.length = "none")
  
  dataF.mx <- as.matrix(dataF[,c(1:6)])
  
  nA<-c(1:length(dataF.mx[,1])) # Define a vector with row count
  
  #Min heat color
  col2rgb("#FFFFBF")
  rmin <- 1
  gmin <- 1
  bmin <- 191/255
  
  #Max Heat color for Postivie value
  rPmax <- 213/255
  gPmax <- 94/255
  bPmax <- 0
  
  #Max Heat color for Negative value
  col2rgb("#0072B2")
  rNmax <- 0
  gNmax <- 144/255
  bNmax <- 178/255  
  
  #viewport solution at : https://stackoverflow.com/questions/14124373/combine-base-and-ggplot-graphics-in-r-figure-window#14125565
  t.ggtree
  vp.right <- viewport(just =c("right","bottom"), height = unit(1, "npc"), width = unit(0.3, "npc"), x=0.3, y=0.015)
  #plot.new()
  #print(t.ggtree, vp=vp.right)
  
  par(bty="n",mar=c(0,0.2,0,0))
  
  plot(10,10, #Plot axis
       xlim=c(0, length(dataF.mx[1,])+0.5), #x axis as the number of column (=contrast)
       ylim=c(-3, length(dataF.mx[,1])), #y axis as the number of row (=DAA)
       xaxt="n", 
       yaxt="n", 
       xlab=NA, ylab=NA) # remove the actual output of axis
  
  par(bty="n", mar=c(0,0,0,0), 
      new=TRUE)
  print(t.ggtree, vp=vp.right)
  
  
  void<-sapply(nA,function(x){ #iterate of the DAA (=row)
    vx<-dataF.mx[x,] #Define vx as a vector of all column for the current line
    vNAx<-ifelse(is.na(vx)==T,0,vx) #Create a Vector with NA value as equal to zero
    
    #Create all polygon coordinate for the entire row
    x1 <- c(1:length(vx))-0.5 #define 1rst ppoint of the polygon
    x2 <- c(1:length(vx))+0.5 #define second point of the polygon
    y1 <- seq(x,x,length.out=length(vx))-0.5 #define 3rd point of the polygon
    y2 <- seq(x,x,length.out=length(vx))+0.5 #define 4th point of the polygon
    
    #Plot text for the current row
    par(fig=c(0.6,1,0,1), bty="n",mar=c(0,0,0,0), new=T)
    text(x=0, y=x, paste(dataF[x, "tip.label"]), cex = 0.5, pos = 4, family="Palatino",font = 1)
    
    
    par(fig=c(0.21,0.66,0,1),
        bty="n",
        #new=T,
        mar=c(0,4,0,0.2))
    
    void<-sapply(c(1:length(vNAx)), function(i){ #iterate over the contrast
      ifelse(vNAx[i]==0,
             yes = col <- "grey",
             no = ifelse(vNAx[i]>0,
                         yes = col <- rgb(red = rmin-(rmin-rPmax)*((vNAx[i]-1)/(max(dataF.mx, na.rm = T)-1)),
                                          green = gmin-(gmin-gPmax)*((vNAx[i]-1)/(max(dataF.mx, na.rm = T)-1)),
                                          blue = bmin-(bmin-bPmax)*((vNAx[i]-1)/(max(dataF.mx, na.rm = T)-1))),
                         
                         no =  col <- rgb(red = rmin-(rmin-rNmax)*((vNAx[i]+1)/(min(dataF.mx, na.rm = T)+1)),
                                          green = gmin-(gmin-gNmax)*((vNAx[i]+1)/(min(dataF.mx, na.rm = T)+1)),
                                          blue = bmin-(bmin-bNmax)*((vNAx[i]+1)/(min(dataF.mx, na.rm = T)+1)))
             )
      )
      
      polygon(x=c(x1[i], x2[i], x2[i], x1[i]), 
              y=c(y1[i], y1[i], y2[i], y2[i]),
              col= col,
              border = "grey", lwd=1)
      
    })
    
    
  })
  
  ### Legend
  cS <- c(-length(dataF.mx[1,]):-1,0:length(dataF.mx[1,]))
  
  void<-sapply(1:length(cS),function(x){
    ifelse(cS[x]>0, 
           yes = col <- rgb(red = rmin-(rmin-rPmax)*(cS[x]/max(cS)),
                            green = gmin-(gmin-gPmax)*(cS[x]/max(cS)),
                            blue = bmin-(bmin-bPmax)*(cS[x]/max(cS))),
           no =  col <- rgb(red = rmin-(rmin-rNmax)*(cS[x]/min(cS)),
                            green = gmin-(gmin-gNmax)*(cS[x]/min(cS)),
                            blue = bmin-(bmin-bNmax)*(cS[x]/min(cS)))
    )
    aDj=0.25
    Mn <- 1/2+aDj #Min scale
    Mx <- length(dataF.mx[1,])+aDj #Max Scale
    dMnMx <- Mx-Mn #distance Min to Max Scale
    
    vMn <- min(cS)  #Min value
    vMx <- max(cS)  #Max Value
    dV <- dist(c(vMn,vMx)) #Distance max: distance min to max value
    
    dMnX <- dist(c(vMn, cS[x])) #Current Distance: distance minValue to current value
    dR <- dMnX/dV #Distance ratio between current distance and max distance
    
    xCf <- Mn+dMnMx*dR #Final coordonate : applying distance-value-ratio to distance scale
    
    polygon(x=c(xCf-aDj, xCf+aDj, xCf+aDj, xCf-aDj), 
            y=c(-3,-3,-2,-2),
            col=col,
            border = "grey", lwd=1)
    })
  }

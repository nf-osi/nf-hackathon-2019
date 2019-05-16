
# This file was adapted from the following file:https://raw.githubusercontent.com/sgosline/NEXUS/master/bin/nf1TumorHarmonization.R

############################################
require(tidyverse)

## Added env$tab to output multiple things from the same function

#
# plot metadata to display variety of samples
#
plotMetadata<-function(fv.tab,prefix){
  ##first plot: summary of data by sex
  ggplot(fv.tab, aes(x=Sex))+
    geom_bar(aes(x=Sex,fill=tumorType),position='dodge')+
    ggtitle(paste(prefix,'RNA-seq sample distribution',sep='::'))
}


#
#Plot genes with metadata
#
analyzeMetdataWithGenes<-function(full.tab,prefix, gene_a, ...){
  #look at some marker genes using normalized zScore
  ggplot(subset(full.tab,Symbol%in%c(gene_a, ...)))+
    geom_jitter(aes(x=Symbol,y=zScore,shape=study,col=tumorType))+
    ggtitle(paste(prefix,'Selected gene counts', sep = '::'))
}

#
#Dimensionality reduction
#
doPcaPlots<-function(full.tab,prefix, env){
  #create matrix
  combined.mat=reshape2::acast(full.tab,Symbol~id,value.var="zScore")
  
  #then remove missing
  missing=which(apply(combined.mat,1,function(x) any(is.na(x))))
  combined.mat=combined.mat[-missing,]
  
  ###PCA 
  library(ggfortify)
  env$tab <- autoplot(prcomp(t(combined.mat))) ##,data=full.tab,shape='study',col='tumorType')

  ###Look at genes contributing to PCs
  loads=prcomp(combined.mat)$x
  
  genes1=rownames(combined.mat)[rev(order(loads[,1]))[1:25]]
  #now take those loadings from pc1
  env$tab1 <- ggplot(subset(full.tab,Symbol%in%genes1[1:10]))+
                    geom_jitter(aes(x=Symbol,y=zScore,col=tumorType,shape=study))+
                    ggtitle(paste(prefix,'Selected gene counts from PC1', sep = '::'))

  genes2=rownames(combined.mat)[rev(order(loads[,2]))[1:25]]
  #now take those loadings from pc2
  env$tab2 <- ggplot(subset(full.tab,Symbol%in%genes2[1:10]))+
              geom_jitter(aes(x=Symbol,y=zScore,col=tumorType,shape=study))+
              ggtitle(paste(prefix,'Selected gene counts from PC2',sep='::'))
}

#
#Single gene plots
#
singleGeneBoxplot<-function(genes.with.meta,gene='NF1'){
  ggplot(subset(genes.with.meta,Symbol==gene))+
    geom_boxplot(aes(x=study,y=zScore,fill=tumorType))+
    coord_flip()+
    ggtitle(paste(gene,'expression'))
}

singleGeneBarplot<-function(genes.with.meta,gene='NF1'){
  ggplot(subset(genes.with.meta,Symbol==gene))+
    geom_bar(aes(x=tumorType,y=zScore,fill=study),stat='identity',position='dodge')+
    ggtitle(paste(gene,'Expression'))+
    ggpubr::rotate_x_text()
}

#
#Fold change in mean gene expression between males and females
#
getMvsF<-function(genes.with.meta){
  
  #take log of counts
  with.log=genes.with.meta%>%mutate(logCounts=log10(totalCounts+0.0001))
  
  ##now take mean across sex,tumor type and gene
  res=with.log%>%
    group_by(tumorType,Symbol,Sex)%>%
    mutate(mcounts=mean(logCounts))%>%
    dplyr::select(tumorType,Sex,Symbol,mcounts)%>%
    unique()%>%spread(Sex,mcounts)%>%
    mutate(MaleVsFemale=male-female)
  
  ## print results
  res
}

#
#Plot fold change
#
diffExBoxplot<-function(res,gene='NF1'){
  ggplot(res)+
    geom_boxplot(aes(x=tumorType,y=MaleVsFemale),outlier.color=NA)+
    ylim(c(-1,1))+
    ggpubr::rotate_x_text()+
    geom_point(data=subset(res,Symbol==gene),mapping=aes(x=tumorType,y=MaleVsFemale),color='red')+
    ggtitle(paste('Log10 fold change of',gene,'in male vs. female'))
}

#
#Visualize GOenrichment using world cloud summaries
#
GOwordcloud<-function(gene_list, organism){
  require(GOsummaries)
  require(gProfileR)
  #Make Wordcloud
  gosummaries_object <- gosummaries(x = gene_list,
                                    organism = organism,
                                    go_branches = c("BP","keg", "rea"),
                                    min_set_size = 50,
                                    max_set_size = 1000,
                                    max_signif = 40,
                                    ordered_query = TRUE,
                                    hier_filtering = "moderate",
                                    wc_algorithm = "top",
                                    wordcloud_legend_title = NULL,
                                    correction_method = "fdr",
                                    domain_size = "annotated")
  
  #Plot wordcloud
  plot(gosummaries_object,
       components = 1:min(10, length(gosummaries_object)),
       panel_height = 0,
       panel_width = 20,
       fontsize = 8,
       term_length = 100,
       wordcloud_colors = c("grey90", "grey50", "black"),
       wordcloud_legend_title = "Enrichment P-Value",
       filename = "NF_Hackathon_GOwordcloud.png")
}

#
#Run GSVA
#
runGSVA<-function(genes.with.meta,env){
  
  library(GSVA)
  library(GSVAdata)
  mat<-reshape2::acast(genes.with.meta,Symbol~id,value.var='zScore')
  missing<-which(apply(mat,1,function(x) any(is.na(x))))
  mat<-mat[-missing,]
  data("c2BroadSets")
  
  library(biomaRt)
  #get mapping from enst to hgnc
  mart = useMart("ensembl", dataset="hsapiens_gene_ensembl")
  my_chr <- c(1:22,'X','Y')
  map <- getBM(attributes=c("entrezgene","hgnc_symbol"),mart=mart,filters='chromosome_name',values=my_chr)
  
  entrez<-map[match(rownames(mat),map[,2]),1]
  mat<-mat[which(!is.na(entrez)),]
  rownames(mat)<-entrez[!is.na(entrez)]
  res=gsva(mat,method='ssgsea',gset.idx.list=c2BroadSets)
  library(pheatmap)
  vars<-apply(res,1,var)
  annotes=genes.with.meta%>%dplyr::select(id,age,Sex,tumorType,cellCulture,study)%>%unique
  rownames(annotes)<-annotes$id
  
  env$tab1 <- pheatmap(res[names(sort(vars)[1:50]),],
                       labels_col=rep("",ncol(res)),
                       fontsize_row = 4,
                       clustering_method = 'ward.D2',
                       annotation_col = dplyr::select(annotes,-id), 
                       width = 16, 
                       height = 8)
  
  env$tab2 <- res[1:5,1:5]
}
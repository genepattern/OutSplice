## try http:// if https:// URLs are not supported
# module specific packages first 
print("- installing")
install.packages("BiocManager")

install.packages(c("getopt", "optparse" ))
#install.packages('gplots')

#BiocManager::install("limma")
BiocManager::install("GenomicRanges")
#BiocManager::install("dplyr")
BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
BiocManager::install("org.Hs.eg.db")
BiocManager::install("Homo.sapiens")
BiocManager::install("Repitools")

BiocManager::install("Mus.musculus")
BiocManager::install("TxDb.Mmusculus.UCSC.mm10.knownGene")
BiocManager::install("TxDb.Mmusculus.UCSC.mm39.refGene")
BiocManager::install("org.Mm.eg.db")

# install.packages("/build/source/OutSplice.tar.gz", repos = NULL, type = "source")
#BiocManager::install("OutSplice")


print("<-#-> Install complete")



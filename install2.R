install.packages(c("getopt", "optparse" ))

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("limma")
BiocManager::install("GenomicRanges")
BiocManager::install("dplyr")
BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
BiocManager::install("org.Hs.eg.db")
BiocManager::install("Homo.sapiens")




#devtools::install_github("https://github.com/gevaertlab/AMARETTO",ref="develop")


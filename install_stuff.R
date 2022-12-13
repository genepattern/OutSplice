## try http:// if https:// URLs are not supported
# module specific packages first 
print("- installing")
#source("http://bioconductor.org/biocLite.R")
install.packages("BiocManager")

BiocManager::install(c("ComplexHeatmap"))





print("<-#-> Install complete")



## The Regents of the University of California and The Broad Institute
## SOFTWARE COPYRIGHT NOTICE AGREEMENT
## This software and its documentation are copyright (2018) by the
## Regents of the University of California abd the 
## Broad Institute/Massachusetts Institute of Technology. All rights are
## reserved.
##
## This software is supplied without any warranty or guaranteed support
## whatsoever. Neither the Broad Institute nor MIT can be responsible for its
## use, misuse, or functionality.

# Load any packages used to in our code to interface with GenePattern.
# Note the use of suppressMessages and suppressWarnings here.  The package
# loading process is often noisy on stderr, which will (by default) cause
# GenePattern to flag the job as failing even when nothing went wrong. 
suppressMessages(suppressWarnings(library(dplyr)))
suppressMessages(suppressWarnings(library(getopt)))
suppressMessages(suppressWarnings(library(optparse)))
suppressMessages(suppressWarnings(library(limma)))
suppressMessages(suppressWarnings(library(GenomicRanges)))
suppressMessages(suppressWarnings(library(TxDb.Hsapiens.UCSC.hg38.knownGene)))
suppressMessages(suppressWarnings(library(org.Hs.eg.db)))
suppressMessages(suppressWarnings(library(Homo.sapiens)))
suppressMessages(suppressWarnings(library(OutSplice)))


# Print the sessionInfo so that there is a listing of loaded packages, 
# the current version of R, and other environmental information in our
# stdout file.  This can be useful for reproducibility, troubleshooting
# and comparing between runs.
sessionInfo()

is.emptyString=function(a){return (trimws(a)=="")}

# Get the command line arguments.  We'll process these with optparse.
# https://cran.r-project.org/web/packages/optparse/index.html
arguments <- commandArgs(trailingOnly=TRUE)

# Declare an option list for optparse to use in parsing the command line.
option_list <- list(
  # Note: it's not necessary for the names to match here, it's just a convention
  # to keep things consistent.
  make_option("--junction.file", dest="junction.file"),
  make_option("--rsem.file", dest="rsem.file"),
  make_option("--rawcounts.file", dest="rawcounts.file"),
  make_option("--sample.labels.file", dest="sample.labels.file"),
  make_option("--out.file.prefix", dest="out.file.prefix"),
  make_option("--dir", dest="dir", default="")  ,
  make_option("--filter.sex", dest="filter.sex", type="logical"),
  make_option("--preset.genome.annotation", dest="preset.genome.annotation", default="hg38"),
  make_option("--annotation", dest="annotation",default=""),
  make_option("--txdb", dest="txdb",default=""),
  make_option("--offsets.value", dest="offsets.value", type="double"),
  make_option("--correction.setting", dest="correction.setting"),
  make_option("--p.value", dest="p.value", type="double"),
  make_option("--use_junc_col", dest="use_junc_col", type="integer", default="1"),
  make_option("--use_gene_col", dest="use_gene_col", type="integer", default="1"),
  make_option("--use_rc_col", dest="use_rc_col", type="integer", default="1"),
  make_option("--use_labels_col", dest="use_labels_col", type="integer", default="1")
)

# Parse the command line arguments with the option list, printing the result
# to give a record as with sessionInfo.
opt <- parse_args(OptionParser(option_list=option_list), positional_arguments=TRUE, args=arguments)
opts <- opt$options
print(opts)

junction = opts$junction.file
rawcounts = opts$rawcounts.file
rsem = opts$rsem.file
sample_labels = opts$sample.labels.file
outdir = opts$dir

if (is.emptyString(outdir)){
    outdir = getwd()
}

if (!(endsWith(outdir, '/'))){
   outdir = paste(outdir, '/', sep="")
}


# set the default genome and annotations and then override if the optional overrides are provided
if (tolower(opts$preset.genome.annotation) == tolower("hg19")){
    # --genome Homo.sapiens --annotation org.Hs.eg.db  --txdb TxDb.Hsapiens.UCSC.hg38.knownGene
    #genome =  "Homo.sapiens"
    annotation = "org.Hs.eg.db"
    txdb = "TxDb.Hsapiens.UCSC.hg19.knownGene"
    library(Homo.sapiens)
    library(org.Hs.eg.db)
    library(TxDb.Hsapiens.UCSC.hg19.knownGene)
} else if (tolower(opts$preset.genome.annotation) == tolower("hg38")){
    #genome = "Homo.sapiens"
    annotation = "org.Hs.eg.db"
    txdb = "TxDb.Hsapiens.UCSC.hg38.knownGene"
    library(Homo.sapiens)
    library(org.Hs.eg.db)
    library(TxDb.Hsapiens.UCSC.hg38.knownGene)
} else if (tolower(opts$preset.genome.annotation) == tolower("mm39")){
    #genome = "Mus.musculus"
    annotation = "org.Mm.eg.db"
    txdb = "TxDb.Mmusculus.UCSC.mm39.refGene"
    library(Mus.musculus)
    library(org.Mm.eg.db)
    library(TxDb.Mmusculus.UCSC.mm39.refGene)
} else if (tolower(opts$preset.genome.annotation) == tolower("mm10")){
    #genome = "Mus.musculus"
    annotation = "org.Mm.eg.db"
    txdb = "TxDb.Mmusculus.UCSC.mm10.knownGene"
    library(Mus.musculus)
    library(org.Mm.eg.db)
    library(TxDb.Mmusculus.UCSC.mm10.knownGene)
}

if (!(is.emptyString(opts$annotation))) {
     annotation = opts$annotation
}
if (!(is.emptyString(opts$txdb))) {
     txdb = opts$txdb
}


# read the second line of the junction file to see if its TCGA format where the second line
# will start with 'junction'
con <- file(junction,"r")
first_lines <- readLines(con,n=2)
close(con)

if (startsWith(first_lines[2], "junction")){
    outspliceTCGA(junction, rsem, rawcounts,  opts$out.file.prefix, outdir, filterSex=opts$filter.sex,  annotation=annotation, TxDb=txdb, offsets_value=opts$offsets.value, correction_setting=opts$correction.setting, p_value=opts$p.value, saveOutput=TRUE)

} else { 
    outspliceAnalysis(junction, rsem, rawcounts, sample_labels, opts$out.file.prefix, outdir, filterSex=opts$filter.sex,  annotation=annotation, TxDb=txdb, offsets_value=opts$offsets.value, correction_setting=opts$correction.setting, p_value=opts$p.value, use_junc_col=opts$use_junc_col,use_gene_col=opts$use_gene_col,use_rc_col=opts$use_rc_col,use_labels_col=opts$use_labels_col, saveOutput=TRUE )

}

# 
# ====== Plots of results
#
date<-Sys.Date()
data_file=paste0(opts$out.file.prefix,"_", date, ".RDa")
data_file=paste0(outdir,"/",data_file)
print(paste("Looking for ", data_file))

pdf <- paste0( opts$out.file.prefix, "", '_top_overexpressed.pdf')
pdf_output <- paste0('./', pdf)

#  ===== FOR PLOTTING =====
# - do we need additional parameters exposed for gene symbol, # junctions to plot, list of juctions (from a file?) 
# - or does the user need to look at the results first in which case plotting should be a second module so that
# - they can first see what junctions they want to plot
# - Alternatively it could be both, just plot the # of top automatically but then have a second plotting module that
# exposes the rest
# default number = 10
exts <- file.exists(data_file)
print(paste0("datafile exists ", exts))

plotJunctionData(data_file, NUMBER=10, junctions=NULL, tail='RIGHT', p_value = opts$p.value, GENE=FALSE, SYMBOL=NULL, makepdf=TRUE, pdffile = pdf_output, tumcol='red', normcol='blue')






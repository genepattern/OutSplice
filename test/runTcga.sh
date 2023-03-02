#!/bin/bash


docker run -w $PWD -v $PWD:$PWD genepattern/outsplice Rscript /build/source/outsplice_wrapper.R --junction.file $PWD/data/TCGA_HNSC_junctions.txt --rawcounts.file $PWD/data/Total_Rawcounts.txt --rsem.file $PWD/data/TCGA_HNSC_genes_normalized.txt --out.file.prefix TCGA_HSNC_outsplice_ --dir $PWD/job/ --filter.sex False --genome Homo.sapiens --annotation org.Hs.eg.db  --txdb TxDb.Hsapiens.UCSC.hg38.knownGene --offsets.value .00001 --correction.setting fdr --p.value .05  





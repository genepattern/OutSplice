#!/bin/bash



docker run -w $PWD -v $PWD:$PWD genepattern/outsplice Rscript /build/source/outsplice_wrapper.R --junction.file $PWD/data/HNSC_junctions.txt --rawcounts.file $PWD/data/Total_Rawcounts.txt --sample.labels.file $PWD/data/HNSC_pheno_table.txt --rsem.file $PWD/data/HNSC_genes_normalized.txt --out.file.prefix HSNC_outsplice_ --dir $PWD/job/ --filter.sex False --genome Homo.sapiens --annotation org.Hs.eg.db  --txdb TxDb.Hsapiens.UCSC.hg38.knownGene --offsets.value .00001 --correction.setting fdr --p.value .05  





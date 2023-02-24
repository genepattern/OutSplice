#!/bin/bash
export TESTDIR=$PWD
cd job

docker run -w $TESTDIR/job -v $TESTDIR:$TESTDIR genepattern/outsplice:0.2 Rscript /build/source/outsplice_wrapper.R --junction.file $TESTDIR/data/HNSC_junctions.txt --rawcounts.file $TESTDIR/data/Total_Rawcounts.txt --sample.labels.file $TESTDIR/data/HNSC_pheno_table.txt --rsem.file $TESTDIR/data/HNSC_genes_normalized.txt --out.file.prefix HSNC_outsplice_  --filter.sex False --genome Homo.sapiens --annotation org.Hs.eg.db  --txdb TxDb.Hsapiens.UCSC.hg38.knownGene --offsets.value .00001 --correction.setting fdr --p.value .05  


cd $TESTDIR


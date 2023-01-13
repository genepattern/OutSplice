# OutSplice v1

**Author(s):** Joseph Bendik, Sandhya Kalavacherla, Michael Considine, Bahman Afsari, Michael F. Ochs, Joseph Califano, Daria A. Gaykalova, Elana Fertig, Theresa Guo.  
**Contact:** Joseph Bendik (jbendik@health.ucsd.edu)
**Adapted as a GenePattern Module by:** Ted Liefeld (jliefeld@cloud.ucsd.edu)

**Task Type:** Clasification

**LSID:**  urn:lsid:genepattern.org:module.analysis:00431


## Introduction
OutSplice is a package that compares alternative splicing events between tumor 
and normal samples. This package is specifically designed for analyzing the gene
and junction information from RNA sequencing data provided by the user, or from 
the TCGA. This package generates a matrix of splicing outliers, which are 
junctions that are either significantly over or under-expressed compared to a 
control sample. OutSplice further designates observed outliers as skipping, 
insertion, or deletion events. Overall, OutSplice is novel in that it determines 
differential splicing burdens between tumors and normal samples and characterizes 
the nature of splicing outliers.

## Functionality

The main functions of OutSplice achieve the following for either user 
provided data or data provided from the TCGA.

1. Junction normalization
2. Outlier analysis
3. Determination of a junctional outlier as a skipping, insertion, or deletion
4. Calculation of splicing burden
5. Plotting expression levels

## References

Cancer Genome Atlas Network. Comprehensive genomic characterization of head and neck squamous cell carcinomas. Nature. 2015 Jan 29;517(7536):576-82. doi: 10.1038/nature14129. PMID: 25631445; PMCID: PMC4311405.

Guo T, Sakai A, Afsari B, Considine M, Danilova L, Favorov AV, Yegnasubramanian S, Kelley DZ, Flam E, Ha PK, Khan Z, Wheelan SJ, Gutkind JS, Fertig EJ, Gaykalova DA, Califano J. A Novel Functional Splice Variant of AKT3 Defined by Analysis of Alternative Splice Expression in HPV-Positive Oropharyngeal Cancers. Cancer Res. 2017 Oct 1;77(19):5248-5258. doi: 10.1158/0008-5472.CAN-16-3106. Epub 2017 Jul 21. PMID: 28733453; PMCID: PMC6042297.

Liu C, Guo T, Sakai A, Ren S, Fukusumi T, Ando M, Sadat S, Saito Y, Califano JA. A novel splice variant of LOXL2 promotes progression of human papillomavirus-negative head and neck squamous cell carcinoma. Cancer. 2020 Feb 15;126(4):737-748. doi: 10.1002/cncr.32610. Epub 2019 Nov 13. PMID: 31721164.

Liu C, Guo T, Xu G, Sakai A, Ren S, Fukusumi T, Ando M, Sadat S, Saito Y, Khan Z, Fisch KM, Califano J. Characterization of Alternative Splicing Events in HPV-Negative Head and Neck Squamous Cell Carcinoma Identifies an Oncogenic DOCK5 Variant. Clin Cancer Res. 2018 Oct 15;24(20):5123-5132. doi: 10.1158/1078-0432.CCR-18-0752. Epub 2018 Jun 26. PMID: 29945995; PMCID: PMC6440699.

M. F. Ochs, J. E. Farrar, M. Considine, Y. Wei, S. Meshinchi, and R. J.  Arceci. Outlier analysis and top scoring pair for integrated data analysis and  biomarker discovery. IEEE/ACM Trans Comput Biol Bioinform, 11: 520-32, 2014. PMCID: PMC4156935

## Methodology

The below sections describe the processes used in the above functions.

1. **Junction RPM normalization**

The program automatically normalizes the junction counts by dividing the 
junction counts by the total raw counts and then dividing each count by 10^6 
to generate RPM junction data.

2.  **OGSA initial filtering**

The dotheogsa function from the Bioconductor package OGSA is sourced to remove 
junctions that may not be biologically relevant due to low expression or that have any difference between tumor and normal. 
In this package, we set a 0.1 RPM expression threshold for pre-filtering. 

3.  **OGSA outlier analysis**

The dotheogsa function is again employed to determine splicing events as 
outliers, which are defined as any normalized junctions that are two standard 
deviations above or below the median of the normal distribution. A Fisher exact 
test is used to determine which junctions are significantly over or under 
expressed in tumors compared to the normal samples.

4.  **Genomic references**

The Bioconductor GenomicRanges packages are used to assign each junction to a 
known gene. The user has the option in the main function to input which genome 
and its associated Bioconductor packages to use as the reference. These Bioconductor 
packages should include the genome object, annotations, and transcript annotations.

Ex) For mouse genomes aligned to mm39, install and load: 
"Mus.musculus" (genome object), "org.Mm.eg.db" (annotations), and "TxDb.Mmusculus.UCSC.mm39.refGene" 
(transcript annotations) using the library() function. Then, when using the OutSplice functions, specify "org.Mm.eg.db" 
for the annotation argument, and "TxDb.Mmusculus.UCSC.mm39.refGene" for the TxDb argument.

Using this genomic assignment, the dotheogsa function determines insertion, skipping, or deletion events based on the following criteria:

insertion: junction that starts outside a known exon
skipping: junction that skips over a known exon
deletion: junction that is inside a known exon but not as its start or end

5.  **Junction expression normalization**

Junction expression is normalized based on its corresponding gene expression 
from the gene_expr input. This is achieved by dividing the junction RPM data by the 
normalized gene expression counts from a junction's corresponding gene. If a junction is aligned
to more than one gene, then the first gene will be the one selected for the normalization.

6.  **Filter by expression via offsets**

Offsets, which the user can specify, sets a minimum value relative to the normal
samples in order to call a junction an outlier. The goal is to remove data with 
low expression that may not be biologically relevant. In this example example, an 
outlier junction must have a normalized expression greater than 0.00001 in 
order to be called an outlier. Any outliers with expressions below this value 
are too low to be relevant for the analysis in this example.

7.  **Splice Burden Calculation**

Sums the number of splicing events in each sample that were marked as a TRUE 
outlier for both over-expressed and under-expressed events. The total number of
outliers is then calculated as the sum of the over and under-expressed outliers.

8.  **Junction Plotting**

Creates bar and waterfall plots of junction expression in both the tumor and
normal samples. The data for these plots comes from the raw junction input, the
gene expression values to reflect overall gene expression, and the junction
expression normalized by gene expression. 


## Parameters

### Input and Output Parameters

- **junction file**<span style="color: red;">*</span>
    - This is a tab-delimited text file containing a matrix of junction raw read counts.  
- **gene expression file**<span style="color: red;">*</span>
    - A matrix of normalized gene expression data. RSEM quartile normalized data is recommended. 
- **rawcounts file**
    - A matrix of raw read counts for each gene. Can either be per gene, or a summed total for each sample.
- **sample labels file**
    - a matrix of phenotypes.
- **output file prefix**
    - user defined string for what the prefix of the output file should be named.
### Genome Annotation Parameters

- **preset genome annotation**
    - Use presets for genome and transcript annotations. This provides a convenient way to set values for the parameters genome, annottion and TxDB for common settings sucg as Hg19, Hg38, mm10 or mm39.  Values selected here will be overridden if values are also provided seperately for the genome, annotation, and TxDB parameters.
- **genome**
    - The bioconductor package containing the genome object to use. e.g. "Homo.sapiens".
- **annotation**
    - The bioconductor package containing the annotations to use. e.g. "org.Hs.eg.db" or "org.Mm.eg.db".
- **TxDB**
    - The bioconductor package containing the transcript annotations to use. e.g. "TxDb.Hsapiens.UCSC.hg38.knownGene", or "TxDb.Hsapiens.UCSC.hg19.knownGene" for TCGA data.

### Advanced Parameters

- **filter sex**
    - When true, ignores sex chromosomes when generating results. True by default.
- **offsets value**
    - The normalized junction expression threshold. Uses 0.00001 by default.
- **correction setting**
    - The correction value to be used for p-value adjustment during Fisher analyses. Uses 'fdr' by default.  Allowed values are fdr, holm, hochberg, hommel, bonferonni, BH, BY.
- **p value**
    - The significance threshold to use during Fisher analyses. Uses 0.05 by default.


## Input Files

1.   junction file  
    junction counts file 
2.  gene expression file  
3. rawcounts file
4. sample labels file
    - A phenotype matrix, in tab-delimited text format, that designates which samples in the junction file belong to the tumor group 
(labeled as "T") and the normal group (labeled as "F"). Please ensure the  matrix file contains a header row with the first column designating the sample names, and the second column designating the phenotype. If using TCGA data,  the two phenotypes are "tumor" and "normal." OutSplice_TCGA can automatically  infer the phenotype of TCGA data using the sample names.   

## Output Files

  1.ASE.type: <output prefix>_event_types.txt.  Tab-separated text file of junction events labeled by type (skipping, insertion, or deletion).
  2.FisherAnalyses:  <output prefix>FisherAnalyses.txt.  Tab-separated text file containing a matrix of junction events containing the number of outliers in the tumor group (outRank), event ranking based on the number of outliers  and tumor under/over expression (var), the Fisher P-Value for under-expressed   events (FisherP1), and the Fisher P-Value for over-expressed events (FisherP2)
  3. geneAnnot:  <output prefix>gene_annotations.txt.  Tab-separated text file containing object containing gene names corresponding to each junction region.
  4.  <output prefix>TumorOverExpression.txt.  Tab-separated text file of junction outliers.  A list containing the logical matrix of TumorOverExpression  "True" indicates an over-expressed event.
  5.  <output prefix>TumorUnderExpression.txt.  Tab-separated text file of junction outliers. A list containing the logical matrix of TumorUnderExpression  "True" indicates an under-expressed event.
  6. splice_burden: splice_burden.txt. A matrix containing the number of Fisher-P significant  over-expressed, under-expressed, and total number of outliers per sample
  7. An RData file with the following data:

  -ASE.type: junction events labeled by type (skipping, insertion, or deletion)
  
  -FisherAnalyses: matrix of junction events containing the number of outliers 
  in the tumor group (outRank), event ranking based on the number of outliers 
  and tumor under/over expression (var), the Fisher P-Value for under-expressed 
  events (FisherP1), and the Fisher P-Value for over-expressed events (FisherP2)
  
  -geneAnnot: object containing gene names corresponding to each junction region
  
  -junc.Outliers: list containing the logical matrices TumorOverExpression and 
  TumorUnderExpression. "True" indicates an over-expressed event in 
  TumorOverExpression, or an under-expressed event in TumorUnderExpression.
  
  -junc.RPM: junction counts in reads per million following a division of the 
  junction counts input by the total rawcounts for each sample
  
  -junc.RPM.norm: junction counts normalized by each event's total gene expression value
  
  -gene_expr: gene expression values for each junction event
  
  -splice_burden: matrix containing the number of Fisher-P significant 
  over-expressed, under-expressed, and total number of outliers per sample
  
  -NORM.gene_expr.norm: Median of Junction Data Normalized by gene expression for Normal Samples
  Only (Used for Junction Plotting Only)
  
  -pheno: Phenotypes of Samples (Tumor or Normal)
  
  -pvalues: Junction Fisher P-values
  

### Example Data



## Version Comments

- **1.0.0** (2023-01-12): Initial draft of document scaffold.

# OutSplice v1

** Author:** Joseph Bendik (jbendik@health.ucsd.edu)
** Adapted as a GenePattern Module by:** Ted Liefeld (jliefeld@cloud.ucsd.edu)
** Algorithm Version: ** 1.0

## Introduction


## Algorithm


## References


## Parameters

## Parameters

- **junction file**<span style="color: red;">*</span>
    - This is a tab-delimited text file containing a matrix of junction raw read counts.  
- **gene expression file**<span style="color: red;">*</span>
    - a matrix of normalized gene expression data. RSEM quartile normalized data is recommended. 

## Input Files

1.  input junction file  
    Gene set enrichment data file in [GCT
    format](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GCT:_Gene_Cluster_Text_file_format_.28.2A.gct.29). Each
    row of the GCT file matrix should represent a gene set while each
    column should represent a sample. Each matrix element should contain
    an enrichment score indicating the degree to which the given gene
    set’s members are coordinately up- or down-regulated in the given
    sample. Output from the [ssGSEAProjection
    module](https://www.broadinstitute.org/cancer/software/genepattern/modules/docs/ssGSEAProjection/) can
    be directly input into ConstellationMap.
2.  gene expression file  
    Class designation file in [CLS
    format](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#CLS:_Categorical_.28e.g_tumor_vs_normal.29_class_file_format_.28.2A.cls.29).

## Output Files

1. Visualizer.html  
    
This is an interactive in-browser plot powered by JavaScript. Open
this link in a new tab to view the ConstellationMap radial plot.
This visualizer allows users to quickly identify and annotate
overlapping genes and interrogate gene set clusters. Metadata such
as Jaccard indices and coordinates are quickly made available.

## Requirements

### Supported Browsers

- **Mozilla Firefox:** v4–46
- **Google Chrome:** v13–41
- **Microsoft IE:** v10–11

*The module developers highly suggest using the latest version of
Firefox or Chrome. JavaScript must be enabled.*

### Platform Dependencies

- **Task Type:** Statistical Methods
- **CPU Type:** any
- **OS:** any
- **Language:** R (v3.0)

## Platform Dependencies

- **Task Type:** Statistical Methods
- **CPU Type:** any
- **Operating System:** any
- **Language:** R

## Version Comments

- **1.0.0** (2023-01-12): Initial draft of document scaffold.

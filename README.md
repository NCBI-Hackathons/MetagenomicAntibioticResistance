# NastyBugs

### A Simple Method for Extracting Antimicrobial Resistance Information from Metagenomes
##### Hackathon team: Lead: Steve Tsang - SysAdmins: Greg Fedewa, Daniel Quang, Sherif Farag - Writers: Matthew Moss, Alexey V. Rakov

#### How to cite this work in a publication:  Tsang H, Moss M, Fedewa G et al. NastyBugs: A simple method for extracting antimicrobial resistance information from metagenomes [version 1; referees: 1 approved with reservations]. F1000Research 2017, 6:1971 
(doi: 10.12688/f1000research.12781.1)

Antibiotic resistance (AMR) of bacterial pathogens is a growing public health threat around the world. Fast and reliable extraction of antimicrobial resistance genomic signatures from large raw sequencing datasets obtained from human metagenomes is a key task for bioinformatics.

**NastyBugs** is a versatile workflow for fast extracting of antimicrobial resistance genomic signatures from metagenomic sequencing data.

*Objective*: Create a reusable, reproducible, scalable, and interoperable workflow 
to locate antimicrobial resistant genomic signatures in SRA shotgun sequencing (including metagenomics) datasets.

This project was part of the [Summer 2017 NCBI Hackathon](https://ncbi-hackathons.github.io/).

## Dependencies:computer:

*Software:*

[Magic-BLAST 1.3](https://ncbi.github.io/magicblast/) is a tool for mapping large next-generation RNA or DNA sequencing runs against a whole genome or transcriptome.

[SAMtools 1.3.1](http://www.htslib.org/) is a suite of programs for interacting with high-throughput sequencing data.

[FASTX-Toolkit](http://hannonlab.cshl.edu/fastx_toolkit/) is a collection of command line tools for Short-Reads FASTA/FASTQ files preprocessing.

[Docker](https://www.docker.com/) is the leading software container platform.

*DBs used for BLAST databases:*

[NCBI GRCh37/UCSC hg19 human reference genome](https://www.ncbi.nlm.nih.gov/projects/genome/guide/human/index.shtml)

[CARD (Comprehensive Antibiotic Resistance Database)](https://card.mcmaster.ca/)

[RefSeq Reference Bacterial Genomes](https://www.ncbi.nlm.nih.gov/refseq/)

## NastyBugs Workflow

![My image](https://github.com/NCBI-Hackathons/MetagenomicAntibioticResistance/blob/master/AbxResistanceMetagenomics.png)

## Workflow method

The pipeline use three databases that should be downloaded with the script:
1.	**GRCh37/hg19 human reference genome database** used for alignment and filtering reads of human origin from metagenomics samples.
2.	**CARD database** used for search of genomic signatures in the subset of reads unaligned to human genome.
3.	**RefSeq reference bacterial genomes database** used for search and assigning of 16S RNA taxonomic labels the subset of reads unaligned to human genome.

Step 1.  Mapping sample SRR to human genome using Magic-BLAST:
```
magicblast13 -sra SRRXXXXXXX -db ~/references/human -num_threads 12 -score 50 -penalty -3 -out ~/test_run/SRRXXXXXXX_human.sam
```

Step 2. Filtering reads mapped to human genome using SAMtools (Removal of host (human) genome from metagenomics data):
```
samtools fasta -f 4 SRRXXXXXXX_human.sam -1 SRRXXXXXXX_read1.fasta  -2 SRRXXXXXXX_read2.fasta -0 SRRXXXXXXX_read0.fasta
fastx_clipper [-i INFILE] [-o OUTFILE]
```

Step 3. Searching 16S RNA taxonomic labels in RefSeq reference bacterial genomes database to identify microbial species presented in metagenome using Magic-BLAST:
```
magicblast13 -infmt fasta -query ~/test_run/SRRXXXXXXX_read1.fasta -query_mate ~/test_run/SRRXXXXXXX_read2.fasta -num_threads 12 -score 50 -penalty -3 -out ~/test_run/SRRXXXXXXX_refseq.sam -db ~/references/REFSEQ
```

Step 4. Searching genes and SNPs from CARD database in metagenome using Magic-BLAST:
```
magicblast13 -infmt fasta -query ~/test_run/SRRXXXXXXX_read1.fasta -query_mate ~/test_run/SRRXXXXXXX_read2.fasta -num_threads 12 -score 50 -penalty -3 -out ~/test_run/SRRXXXXXXX_CARD_SNP.sam -db ~/references/CARD_variant
magicblast13 -infmt fasta -query SRRXXXXXXX_read1.fasta -query_mate SRRXXXXXXX_read2.fasta -num_threads 12 -score 50 -penalty -3 -out SRRXXXXXXX_CARD_gene.sam -db ~/references/CARD_gene
```

Step 5. Converting SAM to BAM format and sorting using SAMtools:
```
samtools view -bS SRRXXXXXXX_SNP.sam | samtools sort - -o SRRXXXXXXX_SNP.bam
samtools view -bS SRRXXXXXXX_CARD_gene.sam | samtools sort - -o SRRXXXXXXX_CARD_gene.bam
```

Step 6. Producing detailed output file(s) including names of detected bacterial species and resistance genes with statistical metrics in text and graphical formats.

## Deliverables

Documented workflow with containerized tools in Docker.

[How to use/run a Docker image](https://github.com/NCBI-Hackathons/Cancer_Epitopes_CSHL/blob/master/doc/Docker.md)

## Installation
```
sudo docker images
sudo docker pull stevetsa/docker-magicblast
sudo docker run -it stevetsa/docker-magicblast
sudo docker ps -a 
```

## Usage
```
main.sh <options> -S SRA -o output_directory
```

## Input file format

SRA accession numbers (ERR or SRR)
or
FASTQ files

## Output

1. Table (in CSV or TAB-delimited format) with the next columns:
* RefSeq accession number (Nucleotide)
* Genus
* Resistance gene
* ARO (Antibiotic Resistance Ontology) accession number
* Score (number of mapped reads per 1kb)

2. Dot plot showing relative abundance of antimicrobial resistance/bacterial species in metagenomic sample.

3. Pie chart vizualization of bacterial abundance in the given dataset using Krona ([Ondov BD, Bergman NH, and Phillippy AM. Interactive metagenomic visualization in a Web browser. BMC Bioinformatics. 2011 Sep 30; 12(1):385](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-385)).

![My image](https://github.com/NCBI-Hackathons/MetagenomicAntibioticResistance/blob/master/MetagenomeVisualization.png)

## Validation

The NastyBugs workflow was validated using the next SRAs: ERR1600439 and SRR5239736.

## Planned Features
1. Code optimization.
2. Improved more detailed output.
3. Prediction of novel resistance genes (using HMM).

## F.A.Q.
1. How to cite?

Tsang H, Moss M, Fedewa G et al. NastyBugs: A simple method for extracting antimicrobial resistance information from metagenomes [version 1; referees: awaiting peer review]. F1000Research 2017, 6:1971 [doi: 10.12688/f1000research.12781.1](https://f1000research.com/articles/6-1971/)

2. How to use?

Follow the instructions on this page.

3. What if I need a help?

Feel free to contact authors if you need help.

## Reference

Tsang H, Moss M, Fedewa G, Farag S, Quang D, Rakov AV, Busby B. NastyBugs: A simple method for extracting antimicrobial resistance information from metagenomes [version 1; referees: awaiting peer review]. F1000Research 2017, 6:1971 [doi: 10.12688/f1000research.12781.1](https://f1000research.com/articles/6-1971/)

## People/Team
* [Steve Tsang](https://github.com/stevetsa), NCI/NIH, Gaithersburg, MD, <tsang@mail.nih.gov>
* [Greg Fedewa](https://github.com/harper357), UCSF, San Francisco, CA, <greg.fedewa@gmail.com>
* [Sherif Farag](https://github.com/SWFarag), UNC, Chapel Hill, NC, <farags@email.unc.edu>
* [Matthew Moss](https://github.com/mmoss609), CSHL, Cold Spring Harbor, NY, <moss@cshl.edu>
* [Daniel Quang](https://github.com/daquang), UCI, Irvine, CA, <dxquang@uci.edu>
* [Alexey V. Rakov](https://github.com/alexeyrakov), UPenn, Philadelphia, PA, <rakovalexey@gmail.com>


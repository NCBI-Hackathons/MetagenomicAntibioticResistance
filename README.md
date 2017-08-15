# MetagenomicAntibioticResistance

### A Simple Method for Extracting Antimicrobial Resistance Information from Metagenomes
##### Hackathon team: Lead: Steve Tsang - SysAdmins: Greg Fedewa, Dan, Sherif Farag - Writers: Matthew Moss, Alexey V. Rakov


*Objective*: Create a reusable, reproducible, scalable, interoperable workflow 
to locate antimicrobial resistant genomic signatures in SRA shotgun sequencing (metagenomics) datasets

## Dependencies:computer:

*Software:*

Magic-BLAST 1.3b [link](https://github.com/boratyng/magicblast)

SAMtools 1.3.1 [link](http://www.htslib.org/)

STAR [link](https://github.com/alexdobin/STAR/releases)

Docker [link](https://www.docker.com/)

*DBs used for BLAST databases:*

hg19 [link](https://www.ncbi.nlm.nih.gov/refseq/)

CARD (Comprehensive Antibiotic Resistance Database) DB [link](https://card.mcmaster.ca/)

RefSeq Reference Bacterial Genomes [link](https://www.ncbi.nlm.nih.gov/refseq/)

## Workflow

![My image](https://github.com/NCBI-Hackathons/MetagenomicAntibioticResistance/blob/master/AbxResistanceMetagenomics.png)

## Deliverables

Documented workflow with containerized tools

## Installation



## Usage

scaleupUpScript.sh <options> -S SRA -o output_directory

## Input file format

SRA accession numbers (ERR or SRR)
or
FASTQ files

## Output

Table (in CSV or TAB-delimited format) with the next columns:
- Accession number (Nucleotide/Protein)
- Name
- ARO (Antibiotic Resistance Ontology)
- Score
- Resistance type

## Warnings


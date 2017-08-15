# MetagenomicAntibioticResistance

### Locating Antibiotic Resistance Signatures in Metagenomic Datasets
##### Hackathon team: Lead: Steve Tsang - SysAdmins: Greg Fedewa, Dan, Sherif Farag - Writers: Matthew Moss, Alexey Rakov


*Objective* - Create a reusable, reproducible, scalable, interoperable workflow 
to locate antimicrobial resistant genomic signatures in SRA shotgun sequencing (metagenomics) datasets

## Dependencies:computer:

###Software:

magicBLAST 1.3b [link](https://github.com/boratyng/magicblast)

SAMtools 1.3.1 [link](http://www.htslib.org/)

STAR [link](https://github.com/alexdobin/STAR/releases)

Docker [link](https://www.docker.com/)

###Pre-assembled DBs for BLAST:

hg19 [link](ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.35_GRCh38.p9/GCF_000001405.35_GRCh38.p9_genomic.fna.gz)

CARD (Comprehensive Antibiotic Resistance Database) DB [link](https://card.mcmaster.ca/)

RefSeq Reference Bacterial Genomes [link](https://www.ncbi.nlm.nih.gov/refseq/)

## Deliverables

Documented workflow with containerized tools

## Instalation

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


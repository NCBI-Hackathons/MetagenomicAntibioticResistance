# MetagenomicAntibioticResistance

# Locating Antibiotic Resistance Signatures in Metagenomic Datasets
Lead: Steve - SysAdm: Greg, Dan, Sherif - Writers: Matt, Aleksei

Objective - Create a reusable, reproducible, scalable, interoperable workflow 
to locate antimicrobial resistant genomic signatures in SRA shot-gun sequencing (metagenomics) Datasets

Deliverables - Documented workflow with containerized tools


Instalation:


Usage:
scaleupUpScript.sh <options> -S SRA -o output_directory

Input:
SRA accession numbers (ERR or SRR)
or
FASTQ files

Output:
Table (in CSV or TAB-delimited format) with the next columns:
- Accession number (Nucleotide/Protein)
- Name
- ARO (Antibiotic Resistance Ontology)
- Score
- Resistance type

Warnings:


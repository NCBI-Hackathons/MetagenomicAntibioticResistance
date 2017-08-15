# MetagenomicAntibioticResistance

# Locating Antibiotic Resistance Signatures in Metagenomic Datasets
Lead: Steve - SysAdm: Greg, Dan, Sherif - Writers: Matt, Aleksei

<i>Objective</i> - Create a reusable, reproducible, scalable, interoperable workflow 
to locate antimicrobial resistant genomic signatures in SRA shot-gun sequencing (metagenomics) Datasets

<i>Deliverables</i> - Documented workflow with containerized tools


<i>Instalation:</i>


<i>Usage:</i>
scaleupUpScript.sh <options> -S SRA -o output_directory

<i>Input:</i>
SRA accession numbers (ERR or SRR)
or
FASTQ files

<i>Output:</i>
Table (in CSV or TAB-delimited format) with the next columns:
- Accession number (Nucleotide/Protein)
- Name
- ARO (Antibiotic Resistance Ontology)
- Score
- Resistance type

<i>Warnings:</i>


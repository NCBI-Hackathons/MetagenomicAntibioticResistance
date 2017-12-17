#!/bin/bash
# Usage: sh NastyBugs.sh inDir hostDir cardDir snpDir nCores outDir

if [ "$#" -ne 6 ]; then
	echo "Not Enough Arguments. Please enter sh nastyBugs.sh [SRA Directory] [Host Genome Directory] [Card Database Directory] [Variant Database Directory] [Available Cores] [Output Directory]"
fi


indir="$1"
hostGen="$2"
card="$3"
snp="$4"
cores="$5"
Out_DIR="$6"

cd "$1"
FILES=./List_IDs

for sra in $FILES; do
  echo "processing $sra"
  # First we align to a host so we can subtract host reads 
  magicblast13 -sra $sra -db $hostGen -num_threads $cores -score 50 -penalty -3 -out $Out_DIR/$sra.human.sam
  samtools fasta -f 4 $indir/$sra.human.sam -1 tmp_read_one -2 tmp_read_two -0 tmp_read_zero
  # should we delete the SAM? 
  # determine if SRA is PE or SE. then run magicblast on the nonhost reads. This could be done by looking at the meta data, too
  read1_count=$(wc -l $tmp_read_one)
  read2_count=$(wc -l $tmp_read_two)
  read0_count=$(wc -l $tmp_read_zero)

  # run magicblast using the CARD gene_homology 
  if [[ ($read0_count -lt $read1_count) && ($read1_count -eq $read2_count) ]]; then
	  fastx_clipper -i $tmp_read_one -o $tmp_read_one_trimmed # is this line still needed? 
	  fastx_clipper -i $tmp_read_two -o $tmp_read_two_trimmed # is this line still needed? 
    # should we sync the FASTQs here?
	  magicblast13 -num_threads $cores  -infmt fasta -query $tmp_read_one_trimmed -query_mate $tmp_read_two_trimmed -score 50 -penalty -3 -out $OUT_DIR/$sra.CARD_gene.sam -db $card
  elif [[ ($read1_count -lt $read0_count) && (-s $read0_count) ]]; then
	  fastx_clipper -i $tmp_read_zero -o $tmp_read_zero_trimmed
	  magicblast13 -num_threads $cores -infmt fasta -query $tmp_read_zero_trimmed -score 50 -penalty -3 -out $OUT_DIR/$sra.CARD_gene.sam -db $card 
  else 
    echo "ERROR: no reads to align to CARD databases"
  fi

  # Convert the gene_homology aligned SAM to BAM and sort. Delete SAM to save space
  samtools view -bS $OUT_DIR/$sra.CARD_gene.sam | samtools sort - $OUT_DIR/$sra.CARD_gene.bam # should we output the unaligned reads to a different bam?
  rm $OUT_DIR/$sra.CARD_gene.sam

  # run magic blast using CARD gene_variant
  if [[ ($read0_count -lt $read1_count) && ($read1_count -eq $read2_count) ]]; then
    magicblast13 -num_threads $cores -infmt fasta -query $tmp_read_one_trimmed -query_mate $tmp_read_two_trimmed -score 50 -penalty -3 -out $OUT_DIR/$sra.CARD_variant.sam -db $card
  elif [[ ($read1_count -lt $read0_count) && (-s $read0_count) ]]; then
    magicblast13 -num_threads $cores -infmt fasta -query $tmp_read_zero_trimmed -score 50 -penalty -3 -out $OUT_DIR/$sra.CARD_variant.sam -db $card
  else 
    echo "ERROR: no reads to align to CARD databases"
  fi


  # Convert the gene_variant aligned SAM to BAM and sort. Delete SAM to save space
  samtools view -bS $OUT_DIR/$sra.CARD_variant.sam | samtools sort - $OUT_DIR/$sra.CARD_variant.bam # should we output the unaligned reads to a different bam?
  rm $OUT_DIR/$sra.CARD_variant.sam

  # process the above bamfiles into a output-usable form 

done > folderOfFinal_output



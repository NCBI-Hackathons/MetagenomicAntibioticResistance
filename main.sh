FILES=./List_IDs
OUT_DIR=pwd
for sra in $FILES
do
  echo "processing $sra"
  # First we align to a host so we can subtract host reads 
  magicblast -sra $sra -db references/hg19.fa -num_threads 12 -out ~/references/outcome_sam_fodler_vhg19
  samtools fasta -f 4 ~/refereneces/outcome_sam_fodler_vhg19 -1 tmp_read_one -2 tmp_read_two -0 tmp_read_zero
  # determine if SRA is PE or SE. then run magicblast on the nonhost reads
  READ1COUNT= wc -l $tmp_read_one
  READ2COUNT= wc -l $tmp_read_two
  READ0COUNT= wc -l $tmp_read_zero
  # run magicblast using the CARD gene_homology 
  if [$READ0COUNT -lt $READ1COUNT -a $READ1COUNT -eq $READ2COUT ]
  then 
    magicblast1.3  -infmt fastq -query $tmp_read_one -query_mate $tmp_read_two -out $OUT_DIR/$sra.CARD_gene.sam -db ~/references/CARD_gene
  else [$READ1COUNT -lt $READ0COUNT -a -s $READ0COUNT ]
  then
    magicblast1.3 -infmt fastq -query $tmp_read_zero -out $OUT_DIR/$sra.CARD_gene.sam -db ~/references/CARD_gene  
  samtools view -bS $OUT_DIR/$sra.CARD_gene.sam | samtools sort - $OUT_DIR/$sra.CARD_gene.bam
  rm 
  # run magic blast using CARD gene_variant
  if [$READ0COUNT -lt $READ1COUNT -a $READ1COUNT -eq $READ2COUT ]
  then
    magicblast1.3 -infmt fastq -query $tmp_read_one -query_mate $tmp_read_two -out $OUT_DIR/$sra.CARD_variant.sam -db ~/references/CARD_variant
  else [$READ1COUNT -lt $READ0COUNT -a -s $READ0COUNT ]
  then
    magicblast1.3  -infmt fastq -query $tmp_read_zero -out $OUT_DIR/$sra.CARD_variant.sam -db ~/references/CARD_variant
magicblast -sra $sra -db references/CARD.nhr -num_threads 12 -out ~/references/outcome_sam_folder_vCARD
  # process above bamfiles
  # samtools bam2fq input.bam | seqtk seq -A > output.fa
done > folderOfFinal_output

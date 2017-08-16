FILES=./List_IDs
OUT_DIR=pwd
for sra in $FILES
do
  #echo "processing $sra"
  # First we align to a host so we can subtract host reads 
  magicblast -sra $sra -db references/human -num_threads 12 -score 50 -penalty -3 -out ~/references/$sra.human.sam
  samtools fasta -f 4 ~/refereneces/$sra.human.sam -1 tmp_read_one -2 tmp_read_two -0 tmp_read_zero
  # determine if SRA is PE or SE. then run magicblast on the nonhost reads
  READ1COUNT= wc -l $tmp_read_one
  READ2COUNT= wc -l $tmp_read_two
  READ0COUNT= wc -l $tmp_read_zero
  # run magicblast using the CARD gene_homology 
  if [$READ0COUNT -lt $READ1COUNT -a $READ1COUNT -eq $READ2COUT ]
  then
	fastx_clipper -i $tmp_read_one -o $tmp_read_one_trimmed
	fastx_clipper -i $tmp_read_two -o $tmp_read_two_trimmed
	magicblast13 -num_threads 12  -infmt fasta -query $tmp_read_one_trimmed -query_mate $tmp_read_two_trimmed -score 50 -penalty -3 -out $OUT_DIR/$sra.CARD_gene.sam -db ~/references/CARD_gene
  else [$READ1COUNT -lt $READ0COUNT -a -s $READ0COUNT ]
  then
	fastx_clipper -i $tmp_read_zero -o $tmp_read_zero_trimmed
	magicblast13 -num_threads 12 -infmt fasta -query $tmp_read_zero_trimmed -score 50 -penalty -3 -out $OUT_DIR/$sra.CARD_gene.sam -db ~/references/CARD_gene  
  samtools view -bS $OUT_DIR/$sra.CARD_gene.sam | samtools sort - $OUT_DIR/$sra.CARD_gene.bam
  rm 
  # run magic blast using CARD gene_variant
  if [$READ0COUNT -lt $READ1COUNT -a $READ1COUNT -eq $READ2COUT ]
  then
    magicblast13 -num_threads 12 -infmt fasta -query $tmp_read_one_trimmed -query_mate $tmp_read_two_trimmed -score 50 -penalty -3 -out $OUT_DIR/$sra.CARD_variant.sam -db ~/references/CARD_variant
  else [$READ1COUNT -lt $READ0COUNT -a -s $READ0COUNT ]
  then
    magicblast13 -num_threads 12 -infmt fasta -query $tmp_read_zero_trimmed -score 50 -penalty -3 -out $OUT_DIR/$sra.CARD_variant.sam -db ~/references/CARD_variant
  # process above bamfiles
  
done > folderOfFinal_output

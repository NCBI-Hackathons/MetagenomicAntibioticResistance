
# coding: utf-8

# In[6]:

import ftplib
import pandas as pd

ftp = ftplib.FTP("ftp.ncbi.nlm.nih.gov")
ftp.login()
bacteria_refSeq_assembly=pd.read_csv("assembly_summary_complete_genomes.csv")
dim = bacteria_refSeq_assembly.shape
for i in xrange(0, dim[0]):
    ftp_path=bacteria_refSeq_assembly.iloc[i, -3]
    #print ftp_path
    ftp_path=ftp_path.split("ftp://ftp.ncbi.nlm.nih.gov/")[1]
    genome_ID= ftp_path.split("/")[6]
    #print "Ftp_genomce_ID: ", genome_ID
    ftp_path += "/"+genome_ID +"_genomic.fna.gz"
    ftp_path_final = "/"+ftp_path
    fileName= genome_ID +"_genomic.fna.gz" 
    #print "File_name: ", fileName
    #print "ftp_path_final: ", ftp_path_final
    #print "############"
    fhandle = open('./bacteria_refseq/%s' % fileName, 'wb')
    ftp.retrbinary('RETR ' + ftp_path_final, fhandle.write)
    fhandle.close()


# In[ ]:




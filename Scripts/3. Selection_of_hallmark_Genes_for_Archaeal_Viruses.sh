Collection reference of Archaeal Viral Genomes
#Firstly,we collected a database for 202 Archaeal Viral Genomes as a reference.
#Then,we predicted genes from the 202 archaeal virus genomes using Prodigal v. 2.6.3 (default parameters) and obtained  proteins encoded by these genes. 

prodigal -f gff -i $fna -o  $gff -a $faa -p meta
#21,985 proteins


#Selection of hallmark Genes for Archaeal Viruses

#(1) Exclusive archaeal viral proteins based on the annotations in the Pfam database

#(i) We collected 35 genomes of archaeal isolates from UHGG catalog and each protein encoded by the genomes was annotated in the Pfam database. 

hmmscan --cpu 28 -E 1e-5 --tblout arc_iso_genome.pfam.hmm /Pfam-A/Pfam-A.hmm arc_iso_genome.prot.faa 

###Only select the top-hit
grep -v "#" arc_iso_genome.pfam.hmm|sort -b -k3,3 -u > arc_iso_genome.pfam_uniq.hmm

##list the id for archaeal protein sequences
less arc_iso_genome.pfam_uniq.hmm|awk '{print $2}' |sort -u > list_pfam.arc_iso_genome.txt


#Each protein encoded by the 35 archaeal genomes was annotated in the Pfam database.  
hmmscan --cpu 28 -E 1e-5 --tblout avseq_202.no_host.pfam.hmm Pfam-A/Pfam-A.hmm avseq_202.no_host.pro.faa 

###Only select the top-hit
grep -v "#" avseq_202.no_host.pfam.hmm|sort -b -k 3,3 -u  > avseq_202.no_host.pfam_top.hmm

##list the id for archaeal viral protein sequences
less avseq_202.no_host.pfam_top.hmm|awk '{print $2}'|sort -u > list_pfam.avseq_202.no_host.txt

#We selected the proteins with the Pfam homologs only occurring on the 202 archaeal viral genomes as hallmark genes. 
grep -v -f list_pfam.arc_iso_genome.txt list_pfam.avseq_202.no_host.txt > list_pfam.arc_vir.exclusive.txt


#(ii) If any proteins encoded by the archaeal virus genomes and the 35 isolated archaeal genomes were annotated in the Pfam database with the keywords including portal, terminase, spike, capsid, sheath, tail, coat, virion, lysin, holin, base plate, lysozyme, head, fiber, whisker, neck, lysis, tapemeasure or structural, then these (n=164) were added to the collection of hallmark genes for archaeal viruses.

grep -f Hallmark_list arc_iso_genome.pfam.hmm|sort -k 2,2 -u  > arc_iso_genome.hallmark_pfam_u.txt

awk -F" " '{print $2}' avseq_202.no_host.hallmark_pfam_u.txt > list_avseq.hallmark_pfam_u.txt

grep -f list_avseq.hallmark_pfam_u.txt avseq_202.no_host.pfam_top.hmm > list_gene.avseq.hallmark_pfam_u.txt



#(2) To include the proviruses in the archaeal genomes, we collected 11 proviruses predicted from the 35 isolated archaeal genomes in UHGG by CheckV29, and then the 249 proteins predicted from the provirus were added to the collection of the hallmark genes for archaeal viruses. 

##Predict prophage by CheckV
export CHECKVDB = checkv-db-v0.6/

checkv end_to_end arc_iso_genome.fa arc_iso_genome/checkv_out -t 28

prodigal -f gff -i arc_iso_genome/checkv_out/proviruses.fna -o arc_iso_genome/checkv_out/proviruses.gff -a arc_iso_genome/checkv_out/proviruses.prot.faa -p meta


#(3) The 5,907 archaeal virus proteins with the best hit to the members of the VOG database were selected.

hmmsearch --cpu 28  -E 1e-5 --tblout avseq_202.no_host.vog.hmm ~/database/VOGdb/hmm/vogdb.hmm avseq_202.no_host.pro.faa


grep -v "#" avseq_202_1.no_host.vog.hmm|sort -k 1,1 -u  > avseq_202.no_host.vog_top.hmm
##5907 proteins


#(4) The 3,368 archaeal virus proteins with the best hit to the members of the VPF database were selected.

hmmscan --cpu 8 -E 1e-5 --tblout avseq_202.no_host.vpf.hmm VPF/final_list.hmms avseq_202.no_host.pro.faa

grep -v "#" avseq_202_1.no_host.vpf.hmm|sort -k 3,3 -u > avseq_202.no_host.vpf_top.hmm
##3368 proteins

#After combining and de-replicating the proteins from these four sources, in total, 8,485 proteins were selected as the hallmark genes for archaeal viruses.



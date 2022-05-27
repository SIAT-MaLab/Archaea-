#CRISPR array identification
#(1)identify CRISPR array from 17,830 gut archaeal contigs detected from the gut metagenomes
for i in `cat list_for_crt_meta`;do java -cp /home/ymwang/software/CRT1.2-CLI.jar crt $i $i.crt;done
#all the archaeal contigs detected by us are list in the list_for_crt 

##Extract spacers from the CRISPR array 
for i in `cat folder_list`;do for j in `cat $i/list`;do a=`echo $j|awk -F".fa" '{print $1}'`; awk '/\[/{ print ">""'$a'""_"$1" "$3}' $i/$j.crt|tr " " "\n" >> feces_CRISPR_spacer.fna ;done;done



#(2)identify CRISPR array from 1,162 species-level archaeal genomes in the UHGG catalogue
grep ">" all_gut_arc_genome_UHGG.fna > list_for_crt_UHGG

for i in `cat list_for_crt_UHGG`;do java -cp /home/ymwang/software/CRT1.2-CLI.jar crt $i $i.crt;done

for i in `cat folder_list`;do for j in `cat $i/list`;do a=`echo $j|awk -F".fa" '{print $1}'`; awk '/\[/{ print ">""'$a'""_"$1" "$3}' $i/$j.crt|tr " " "\n" >> UHGG_CRISPR_spacer.fna ;done;done

#merge the spacers from metagenomes and UHGG
cat feces_CRISPR_spacer.fna UHGG_CRISPR_spacer.fna > gut_archaea_spacer_all.fna

#dereplicated
cdhit-est -i gut_archaea_spacer_all.fna -o HGASDB.fna -c 1 -M 0 -aS 1 -aL 1 -g 1 -n 10 -d 0 -T 28
#13,021 nonredundant CRISPR spacers

makeblastdb -in HGASDB.fna -dbtype nucl -out HGASDB.blastdb




#!/bin/bash
#gb2fasta
awk -v n=1 '/^\/\//{close("file_gb"n);n++;next} {print > "file_gb"n}' *.gb
csplit file_gb* -f "////" {*} -z -s
for gb in `ls *file_gb*`; do
    sequence=`grep "ORIGIN" $gb -A 1000 | cut -c 11-200 | tr -d " "`
    country=`grep "country" $gb | cut -f2 -d "=" | sed 's:"::g'`
    accession=`grep "ACCESSION" $gb | awk '{print $2}'`
    deposit=`grep "LOCUS" $gb  | awk '{print $8}'`
    organism=`grep -i "/organism" $gb | cut -f 2 -d "=" | sed 's:"::g' | sed 's: :_:g'`
    echo ">$accession|$organism|$country|$deposit""$sequence" | sed 's:||:|Not_found|:g' | tee -a dataset_gb.fasta
done
mkdir files_genbank ; mv *.gb files_genbank
rm -rf file_*

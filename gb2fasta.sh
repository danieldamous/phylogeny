#!/bin/bash
#gb2fasta
awk -v n=1 '/^\/\//{close("file_gb"n);n++;next} {print > "file_gb"n}' *.gb
csplit file_gb* -f "////" {*} -z -s
for gb in $(ls *file_gb*); do
    sequence=$(grep "ORIGIN" $gb -A 1000 | cut -c 11-200 | tr -d " ")
    geo_loc=$(grep "geo_loc" $gb | cut -f2 -d "=" | sed 's:"::g' | sed 's: ::g')
    accession=$(grep "ACCESSION" $gb | awk '{print $2}')
    deposit=$(grep "LOCUS" $gb  | awk '{print $8}')
    organism=$(grep -i "/organism" $gb | cut -f 2 -d "=" | sed 's:"::g' | sed 's: :_:g')
    host=$(grep "/host" $gb | cut -f2 -d "=" | sed 's:"::g' | sed 's: :_:g')
    echo ">$accession|$organism|$host|$geo_loc|$deposit""$sequence" | sed 's:||:|Not_found|:g' | tee -a dataset_gb.fasta
done
sed "s:>|.*$::g" *.fasta | awk 'NF > 0' # remove os espaços vazios
mkdir files_genbank ; mv *.gb files_genbank
rm -rf file_*

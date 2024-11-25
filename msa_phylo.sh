#!/bin/bash
# Alinhamento multiplo de sequências (MSA) com clustalw2 e Filogenia com IQTREE.
clustalw2 -infile=$(ls *.fasta) -align -outfile=$(ls *.fasta | cut -f1 -d ".")"_aligned.fasta"

# Verificar o sinal filogenetico utilizando IQTREE2
iqtree2 -s *_aligned.fasta -lmap 1000 -n 0 -m MFP -nt AUTO #nt=threads
# verificar o valor interno (< 30) e somatoria dos vertecis (> 60).

# Filogenia com IQTREE2
iqtree2 -s *_aligned.fasta -alrt 1000 -nt AUTO -redo #nt=threads

#!/bin/bash
# backmap to contigs - Get coverage and improve assembly quality.
#
thread=3
#
contig=$(ls *.fasta | cut -f 1 -d ".")
#
bowtie2-build *.fasta index
bowtie2 --very-sensitive -x index -p $thread -1 01_clean/*R1* -2 01_clean/*R2* -S "$contig"_backmap.sam
samtools view -@ $thread -S -b -F 4 *.sam -o "$contig"_backmap.bam
samtools sort -@ $thread *.bam -o "$contig"_backmap_sorted.bam
samtools coverage *sorted* | cut -f 1,4,6,7 > "$contig"_average_coverage.txt
samtools depth -a *sorted* | cut -f 2,3 > coverage_tab.txt
samtools fastq -@ $thread *_sorted.bam -o "$contig"_temp.fastq
rm *.sam *_backmap.bam

# Second Round # improving assembly - Fill gaps, correct assembly erros.
bowtie2 -x index --very-sensitive --no-unal -p $thread -U *.fastq -S "$contig"_quality.sam
samtools view -@ $thread -S -b -F 4 *.sam -o "$contig"_quality.bam
samtools sort -@ $thread *.sam -o "$contig"_quality_sorted.bam
samtools coverage *sorted* | cut -f 1,4,6,7 > "$contig"_average_coverage_quality.txt
samtools depth -a *_sorted.bam | cut -f 2,3 > "$contig"_coverage_quality.txt
rm *.sam *.bam index* 

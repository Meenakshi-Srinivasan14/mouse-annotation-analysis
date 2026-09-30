#-----------------------------
# Comment
# To keep the commands short below, put the file name in a variable

gtf=Mus_musculus.GRCm38.75_chr1.gtf


#=============================================================================
# QUESTION 1 - WHAT IS ACTUALLY ANNOTATED ON THIS CHROMOSOME?
#=============================================================================

# a. How many genes are annotated?

# A gene is a line whose THIRD column is exactly "gene"
# -F"\t" tells awk that columns are separated by tabs
# This matters here: the 9th column contains spaces, so without -F"\t"
# awk would split that column into pieces (see Question 4)

grep -v "^#" $gtf | awk -F"\t" '$3=="gene"' | wc -l

## result:
## 2027

#-----------------------------

# b. Break the genes down by biotype

# grep  drops the header lines
# awk   keeps only the gene lines
# sed   replaces the whole line with just the biotype value
# sort | uniq -c | sort -nr  counts and ranks
#
# How the sed works:
#   .*                  match anything before
#   gene_biotype "      the literal text we are looking for
#   \([^"]*\)           CAPTURE everything that is not a quote  <- this is \1
#   ".*                 the closing quote and anything after
#   /\1/                replace the whole line with what was captured
# Parentheses have to be escaped as \( \) to act as grouping in basic sed.
# This is the same capture-group idea used on FASTA headers, applied to a
# longer string.

grep -v "^#" $gtf \
 | awk -F"\t" '$3=="gene"' \
 | sed 's/.*gene_biotype "\([^"]*\)".*/\1/' \
 | sort | uniq -c | sort -nr

## result:
##    1240 protein_coding
##     221 pseudogene
##     118 miRNA
##     105 snRNA
##      99 snoRNA
##      89 lincRNA
##      73 antisense
##      31 misc_RNA
##      23 rRNA
##      20 processed_transcript
##       5 sense_intronic
##       2 polymorphic_pseudogene
##       1 sense_overlapping
##
## The counts add up to 2027, which is the check that nothing was lost.

#-----------------------------

###############################################
#   Convert sequences table to .fasta format  #
# Developped by Rémi Maglione For kembel Lab  #
###############################################

require(Biostrings)

convertTableToFasta <- function(sequence_table, output_file) {
  # Create a DNAStringSet object from the sequence_table
  dna_sequences <- DNAStringSet(sequence_table$oligo)
  
  # Set the names of the DNAStringSet using the sequence names
  names(dna_sequences) <- sequence_table$name
  
  # Write the DNAStringSet to a FASTA file
  writeXStringSet(dna_sequences, file = output_file, format = "fasta")
}

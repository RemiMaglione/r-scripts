his R script was built as a 'rustine' to overcome format issue between kaiju 1.7.3 and Anvi'o 6.2

kaiju2anvio will yield a tab separated taxonomic file with column #1 sheltering the sequence name and column #2 to #8 filled with 'superkingdom phylum order class family genus species' as requested by Anvi'o 6.2 

You have to feed this rustine with the file yielded by the following kaiju command : 

`addTaxonNames -t /path/to/nodes.dmp -n /path/to/names.dmp -i gene_calls_nr.out -o gene_calls_nr.names -r superkingdom,phylum,order,class,family,genus,species`

After creating the kaiju fixed matrix, you're ready for the Anvi'o import with the <b>'default_matrix'</b> parameter: 

`anvi-import-taxonomy-for-genes -c CONTIGS.db -i kaiju2Anvio-fixed.names -p default_matrix`

# USAGE
### Basic
`Rscript kaiju2anvio.R  gene_calls_nr.names gene_calls_nr-fixed.names`

### Lazy 
`Rscript kaiju2anvio.R  gene_calls_nr.names`
(will let the 'rustine' choose the output name, let say "kaiju2Anvio-fixed.names")

### Parallel
By default kaiju2anvio will take all your available cores-1, but you can set this parameter yourself, cool hun ?!

`Rscript kaiju2anvio.R  gene_calls_nr.names gene_calls_nr-fixed.names 12`
will use 12 cores

Obviously, If you try to set more cores than you have, I can't do anything for you (I'm not a bio-informatician after all)

As things always different than we dream of, this little 'rustine' can turn to be a monster: I ran it with a big 20+ million-line table on a server with 60 cores and it completely ate my 500Go of RAM

--- Know your limits, keep calm and thread low ---

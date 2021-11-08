nextflow.enable.dsl=2

process runPopulateIngest {
    output:
    file 'new_data.tsv'
      

    shell:
    '''
    # Could use a docker image here with populate_ingest installed
    # $(cd ~/projects/ebi/hca-ebi-dev-team/scripts/populate_ingest && python3 -m populate_ingest.populate_ingest_from_nxn)

    cat ~/projects/ebi/hca-ebi-dev-team/scripts/populate_ingest/new_nxn_data.tsv > new_data.tsv
    '''
}

process getPublications {
    input:
    file 'new_data.tsv'

    output:
    path 'publications.txt'

    publishDir './saved'

    shell:
    '''
    awk -F"\t" '{print $2","$5}' new_data.tsv | tail -n +2 > publications.txt
    '''
}

process downloadPublication {
    input:
    tuple val(doi), val(title)

    output:
    file '*.html'

    publishDir './saved/publications'

    shell:
    '''
    curl -L https://doi.org/!{doi} > "!{title}".html
    '''
}

process runGeoToHca {

}

workflow {
    new_data = runPopulateIngest

    getPublications(new_data) | splitText | splitCsv | map { new Tuple(it[0], it[1]) } | downloadPublication

    
}
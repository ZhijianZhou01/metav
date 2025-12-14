awk '
BEGIN {
    OFS="\t";
    print "Accession", "order", "family", "Organism (strain or specise)"
}
/^VERSION/ {
    version = $2
}
/\/organism="/ {
    split($0, parts, "\"");
    organism = parts[2];
}
/^  ORGANISM/ {
    taxonomy = "";
    getline;
    while (getline > 0 && $0 !~ /^REFERENCE/ && $0 !~ /^[[:space:]]*$/) {
        taxonomy = taxonomy " " $0;
    }
    
    order = "Unknown";
    family = "Unknown";
    
    if (taxonomy ~ /[A-Z][a-z]+ales/) {
        match(taxonomy, /[A-Z][a-z]+ales/);
        order = substr(taxonomy, RSTART, RLENGTH);
    }
    if (taxonomy ~ /[A-Z][a-z]+dae/) {
        match(taxonomy, /[A-Z][a-z]+dae/);
        family = substr(taxonomy, RSTART, RLENGTH);
    }
    
    if (order == "Unknown" || family == "Unknown") {
        split(taxonomy, taxa_arr, ";");
        for(i in taxa_arr) {
            gsub(/^[ \t]+|[ \t]+$/, "", taxa_arr[i]);
            if (order == "Unknown" && taxa_arr[i] ~ /ales$/) {
                order = taxa_arr[i];
            }
            if (family == "Unknown" && taxa_arr[i] ~ /dae$/) {
                family = taxa_arr[i];
            }
        }
    }
}
/^\/\// {
    if (version != "" && organism != "") {
        print version, order, family, organism;
    }
    version = "";
    organism = "";
    order = "Unknown";
    family = "Unknown";
}
' viral.1.protein.gpff > viral_extracted_info.txt
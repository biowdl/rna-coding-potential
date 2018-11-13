version 1.0

import "tasks/CPAT.wdl" as cpat

# Import common to get the reference struct
import "tasks/common.wdl" as common

workflow RnaCodingPotential {
    input {
        String outputDir
        File? transcriptsFasta
        File? transcriptsBed
        Reference? reference
        String cpatModel = "Human"

    }

    call cpat.CPAT as CPAT {
        input:
            # cpat accepts transcripts in both Fasta and Bed format
            gene = select_first([transcriptsFasta, transcriptsBed]),
            referenceGenome = reference.fasta,
            referenceGenomeIndex = reference.fai,
            hex = cpatModel,
            logitModel=cpatModel,
            outFilePath=outputDir + "/cpat.tsv"
    }

}
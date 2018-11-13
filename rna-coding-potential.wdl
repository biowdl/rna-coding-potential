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
        File cpatLogitModel
        File cpatHex
    }

    File? referenceFasta = if defined(reference) then select_first([reference]).fasta else reference # Should be `else none`
    File? referenceFastaIndex = if defined(reference) then select_first([reference]).fai else reference # Should be `else none`

    call cpat.CPAT as CPAT {
        input:
            # cpat accepts transcripts in both Fasta and Bed format
            gene = select_first([transcriptsFasta, transcriptsBed]),
            referenceGenome = referenceFasta,
            referenceGenomeIndex = referenceFastaIndex,
            hex = cpatHex,
            logitModel = cpatLogitModel,
            outFilePath = outputDir + "/cpat.tsv"
    }
}

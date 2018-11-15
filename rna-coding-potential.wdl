version 1.0

import "tasks/CPAT.wdl" as cpat
import "tasks/gffread.wdl" as gffread

# Import common to get the reference struct
import "tasks/common.wdl" as common

workflow RnaCodingPotential {
    input {
        String outputDir
        File transcriptsGff
        Reference reference
        File cpatLogitModel
        File cpatHex
    }

    File referenceFasta = reference.fasta
    File referenceFastaIndex = reference.fai

    call gffread.GffRead as gffread {
        input:
            inputGff = transcriptsGff,
            genomicSequence = referenceFasta,
            genomicIndex = referenceFastaIndex,
            exonsFastaPath = outputDir + "/transcripts.fasta"
    }

    call cpat.CPAT as CPAT {
        input:
            gene = select_first([gffread.exonsFasta]),
            referenceGenome = referenceFasta,
            referenceGenomeIndex = referenceFastaIndex,
            hex = cpatHex,
            logitModel = cpatLogitModel,
            outFilePath = outputDir + "/cpat.tsv"
    }
}

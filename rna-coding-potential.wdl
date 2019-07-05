version 1.0

import "tasks/CPAT.wdl" as cpat
import "tasks/gffread.wdl" as gffread

# Import common to get the reference struct
import "tasks/common.wdl" as common

workflow RnaCodingPotential {
    input {
        String outputDir = "."
        File transcriptsGff
        File referenceFasta
        File referenceFastaIndex
        File cpatLogitModel
        File cpatHex
        Map[String, String] dockerImages = {
            "gffread": "quay.io/biocontainers/gffread:0.9.12--0",
            "cpat": "biocontainers/cpat:v1.2.4_cv1"
        }
    }

    call gffread.GffRead as gffread {
        input:
            inputGff = transcriptsGff,
            genomicSequence = referenceFasta,
            genomicIndex = referenceFastaIndex,
            exonsFastaPath = outputDir + "/transcripts.fasta",
            dockerImage = dockerImages["gffread"]
    }

    call cpat.CPAT as CPAT {
        input:
            gene = select_first([gffread.exonsFasta]),
            referenceGenome = referenceFasta,
            referenceGenomeIndex = referenceFastaIndex,
            hex = cpatHex,
            logitModel = cpatLogitModel,
            outFilePath = outputDir + "/cpat.tsv",
            dockerImage = dockerImages["cpat"]
    }

    output {
        File cpatOutput = CPAT.outFile
    }
}

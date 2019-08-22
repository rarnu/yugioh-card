package com.rarnu.ygo.server

import io.ktor.network.tls.certificates.generateCertificate
import java.io.File


object CertificateGenerator {
    @JvmStatic
    fun main(args: Array<String>) {
        val jksFile = File("build/rarnu.jks").apply {
            parentFile.mkdirs()
        }

        if (!jksFile.exists()) {
            generateCertificate(jksFile)
        }
    }

}

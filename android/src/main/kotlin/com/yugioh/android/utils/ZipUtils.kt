package com.yugioh.android.utils

import java.io.*
import java.nio.charset.Charset
import java.util.ArrayList
import java.util.Enumeration
import java.util.zip.ZipEntry
import java.util.zip.ZipException
import java.util.zip.ZipFile
import java.util.zip.ZipOutputStream

object ZipUtils {
    private val BUFF_SIZE = 1024 * 1024
    private val ENCODE_GB2312 = "GB2312"
    private val ENCODE_8859_1 = "8859_1"

    fun zipFiles(resFileList: Collection<File>?, zipFile: File?) = zipFiles(resFileList, zipFile, "")

    fun zipFiles(resFileList: Collection<File>?, zipFile: File?, comment: String?) {
        val zipout = ZipOutputStream(BufferedOutputStream(FileOutputStream(zipFile), BUFF_SIZE))
        if (resFileList != null) {
            for (resFile in resFileList) {
                zipFile(resFile, zipout, "")
            }
        }
        zipout.setComment(comment)
        zipout.close()
    }

    fun unzipFile(zipFile: File, folderPath: String) {
        val desDir = File(folderPath)
        if (!desDir.exists()) {
            desDir.mkdirs()
        }
        val zf = ZipFile(zipFile)
        val entries = zf.entries()
        while (entries.hasMoreElements()) {
            val entry = entries.nextElement()
            val ins = zf.getInputStream(entry)
            var str = folderPath + File.separator + entry.name
            str = String(str.toByteArray(Charset.forName(ENCODE_8859_1)), Charset.forName(ENCODE_GB2312))
            val desFile = File(str)
            if (!desFile.exists()) {
                val fileParentDir = desFile.parentFile
                if (!fileParentDir.exists()) {
                    fileParentDir.mkdirs()
                }
                desFile.createNewFile()
            }
            val out = FileOutputStream(desFile)
            val buffer = ByteArray(BUFF_SIZE)
            var realLength: Int
            while (true) {
                realLength = ins.read(buffer)
                if (realLength <= 0) {
                    break
                }
                out.write(buffer, 0, realLength)
            }
            ins.close()
            out.close()
        }
    }

    fun unzipSelectedFile(zipFile: File, folderPath: String, nameContains: String): ArrayList<File> {
        val fileList = ArrayList<File>()
        val desDir = File(folderPath)
        if (!desDir.exists()) {
            desDir.mkdir()
        }

        val zf = ZipFile(zipFile)
        val entries = zf.entries()
        while (entries.hasMoreElements()) {
            val entry = entries.nextElement()
            if (entry.name.contains(nameContains)) {
                val ins = zf.getInputStream(entry)
                var str = folderPath + File.separator + entry.name
                str = String(str.toByteArray(Charset.forName(ENCODE_8859_1)), Charset.forName(ENCODE_GB2312))
                val desFile = File(str)
                if (!desFile.exists()) {
                    val fileParentDir = desFile.parentFile
                    if (!fileParentDir.exists()) {
                        fileParentDir.mkdirs()
                    }
                    desFile.createNewFile()
                }
                val out = FileOutputStream(desFile)
                val buffer = ByteArray(BUFF_SIZE)
                var realLength: Int
                while (true) {
                    realLength = ins.read(buffer)
                    if (realLength <= 0) {
                        break
                    }
                    out.write(buffer, 0, realLength)
                }
                ins.close()
                out.close()
                fileList.add(desFile)
            }
        }
        return fileList
    }

    fun getEntriesNames(zipFile: File): ArrayList<String> {
        val entryNames = ArrayList<String>()
        val entries = getEntriesEnumeration(zipFile)
        if (entries != null) {
            while (entries.hasMoreElements()) {
                val entry = entries.nextElement()
                entryNames.add(String(getEntryName(entry).toByteArray(Charset.forName(ENCODE_GB2312)), Charset.forName(ENCODE_8859_1)))
            }
        }
        return entryNames
    }

    fun getEntriesEnumeration(zipFile: File?): Enumeration<out ZipEntry?>? = ZipFile(zipFile).entries()

    fun getEntryComment(entry: ZipEntry): String = String(entry.comment.toByteArray(Charset.forName(ENCODE_GB2312)), Charset.forName(ENCODE_8859_1))

    fun getEntryName(entry: ZipEntry?): String = String(entry?.name?.toByteArray(Charset.forName(ENCODE_GB2312))!!, Charset.forName(ENCODE_8859_1))

    private fun zipFile(resFile: File, zipout: ZipOutputStream, rootpath: String) {
        var rootpath = rootpath
        rootpath += (if (rootpath.trim { it <= ' ' }.isEmpty()) "" else File.separator) + resFile.name
        rootpath = String(rootpath.toByteArray(Charset.forName(ENCODE_8859_1)), Charset.forName(ENCODE_GB2312))
        if (resFile.isDirectory) {
            val fileList = resFile.listFiles()
            for (file in fileList) {
                zipFile(file, zipout, rootpath)
            }
        } else {
            val buffer = ByteArray(BUFF_SIZE)
            val ins = BufferedInputStream(FileInputStream(resFile), BUFF_SIZE)
            zipout.putNextEntry(ZipEntry(rootpath))
            var realLength: Int
            while (true) {
                realLength = ins.read(buffer)
                if (realLength <= 0) {
                    break
                }
                zipout.write(buffer, 0, realLength)
            }
            ins.close()
            zipout.flush()
            zipout.closeEntry()
        }
    }
}

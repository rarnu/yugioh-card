@file:Suppress("SqlDialectInspection", "SqlNoDataSourceInspection")

import com.github.kilianB.hashAlgorithms.PerceptiveHash
import java.awt.image.BufferedImage
import java.io.File
import java.sql.DriverManager
import javax.imageio.ImageIO

const val LEN = 32
const val DBDRIVER = "com.mysql.cj.jdbc.Driver"
const val DBURL = "jdbc:mysql://localhost:3306/YGOData?useUnicode=true&characterEncoding=UTF-8"
const val DBUSER = "root"
const val DBPASSWORD = "root"

fun getSize(src: BufferedImage, callback: (BufferedImage, Int, Int) -> BufferedImage) =
    callback(src, src.width, src.height)

fun subImage(src: BufferedImage, name: String) = getSize(src) { img, w0, h0 ->
    img.getSubimage((w0 * 0.156).toInt(), (h0 * 0.235).toInt(), (w0 * 0.688).toInt(), (h0 * 0.47).toInt()).apply {
        ImageIO.write(this, "jpg", File(name))
    }
}

fun main(args: Array<String>) {
    Class.forName(DBDRIVER)
    val conn = DriverManager.getConnection(DBURL, DBUSER, DBPASSWORD)
    val hasher = PerceptiveHash(LEN)
    File("image").listFiles()?.forEach {
        val img = ImageIO.read(it)
        val b = subImage(img, "head/${it.name}")
        val hash = hasher.hash(b)
        conn.prepareStatement("insert into ImageHash(cardid, hashcode) values (?, ?)").use { s ->
            s.setInt(1, it.nameWithoutExtension.toInt())
            s.setString(2, hash.hashValue.toString())
            if (s.executeUpdate() <= 0) {
                println("error: ${it.absolutePath}")
            }
        }
    }
}
import com.rarnu.common.DownloadState
import com.rarnu.common.download
import java.io.File

fun main(args: Array<String>) {
    val path = File("image").apply { if (!exists()) mkdirs() }
    (0..9738).forEach {
        download {
            url = "http://ocg.resource.m2v.cn/$it.jpg"
            localFile = File(path, "$it.jpg").absolutePath
            progress { state, _, _, error ->
                if (state == DownloadState.WHAT_DOWNLOAD_FINISH) {
                    println("download $it ${if (error != null) "[$error]" else ""}")
                }
            }
        }
    }
}
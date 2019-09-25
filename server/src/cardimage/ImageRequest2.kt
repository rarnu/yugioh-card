@file:Suppress("BlockingMethodInNonBlockingContext")

package com.rarnu.ygo.server.cardimage

import com.github.kilianB.hashAlgorithms.PerceptiveHash
import com.rarnu.ktor.config
import io.ktor.application.Application
import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO

object ImageRequest2 {

    suspend fun matchImage(app: Application, file: File, callback: suspend (String) -> Unit) {
        val len = app.config("ktor.image.hashlength").toInt()
        val hasher = PerceptiveHash(len)
        // 获取原始图片和小图片的 hash 值
        val imgOrigin = ImageIO.read(file)
        val imgSub = subImage(imgOrigin, file.absolutePath + ".sub")
        val hashOrigin = hasher.hash(imgOrigin)
        val hashSub = hasher.hash(imgSub)
        // 过滤原始图片的匹配度, 0.20 为较不精确的匹配，0.15为较精确的匹配
        val mOriginBig = cardImageCache.filterKeys { it.normalizedHammingDistance(hashOrigin) < 0.20 }
        val mOriginSmall = mOriginBig.filterKeys { it.normalizedHammingDistance(hashOrigin) < 0.15 }
        // 如果精确结果小于2个，取更大范围的结果
        val mOrigin = if (mOriginSmall.size < 2) mOriginBig else mOriginSmall
        // 获取小图片的匹配度
        val mSubBig = cardImageCache.filterKeys { it.normalizedHammingDistance(hashSub) < 0.20 }
        val mSubSmall = mSubBig.filterKeys { it.normalizedHammingDistance(hashSub) < 0.15 }
        val mSub = if (mSubSmall.size < 2) mSubBig else mSubSmall
        // 最结结果相加
        val mfinal = mOrigin + mSub
        // 返回匹配到的卡图序号列表
        when {
            mfinal.isEmpty() -> callback("{\"result\":1}")
            mfinal.size == 1 -> callback("{\"result\":0, \"imgids\":[\"${mfinal.values.elementAt(0)}\"]}")
            else -> callback("{\"result\":0, \"imgids\":[${mfinal.values.joinToString(",") { "\"$it\"" }}]}")
        }
        // 处理完，删掉原始图片和小图
        File(file.absolutePath + ".sub").delete()
        file.delete()
    }

    private fun getSize(src: BufferedImage, callback: (BufferedImage, Int, Int) -> BufferedImage) =
        callback(src, src.width, src.height)

    private fun subImage(src: BufferedImage, name: String) = getSize(src) { img, w0, h0 ->
        img.getSubimage((w0 * 0.156).toInt(), (h0 * 0.235).toInt(), (w0 * 0.688).toInt(), (h0 * 0.47).toInt()).apply {
            ImageIO.write(this, "jpg", File(name))
        }
    }

}
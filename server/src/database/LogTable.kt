package com.rarnu.ygo.server.database

import com.rarnu.common.forEach
import com.rarnu.common.int
import com.rarnu.common.long
import com.rarnu.common.string
import com.rarnu.ktor.conn
import io.ktor.application.Application

class LogTable(private val app: Application) {

    fun search(sql: String): String {
        if (sql.contains("drop") || sql.contains("1=1")) {
            return ""
        }
        var preSql = "select * from Log"
        if (sql != "") {
            preSql += " where $sql"
        }
        val stmt = app.conn.prepareStatement(preSql)
        val rs = stmt.executeQuery()
        var html = "<table><tr><td>ID</td><td>time</td><td>req</td><td>succ</td><td>elapsed</td><td>error</td></tr>"
        rs.forEach {
            html += """
                <tr>
                    <td>${it.int("id")}</td>
                    <td${it.long("timeinfo")}></td>
                    <td>${it.string("req")}</td>
                    <td>${it.int("result")}</td>
                    <td>${it.long("waste")}</td>
                    <td>${it.string("reason")}</td>
                </tr>
            """.trimIndent()
        }
        html += "</table>"
        rs.close()
        return html
    }

}

val Application.sqlLog: LogTable get() = LogTable(this)
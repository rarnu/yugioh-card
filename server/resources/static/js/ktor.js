function searchLog(sql, callback) {
    $.ajax({
        url: '/sql',
        dataType: 'text',
        type: 'POST',
        data: {
            sql: sql
        },
        success: function (data) {
            callback(data);
        }
    });
}
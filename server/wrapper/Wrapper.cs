using System;
using System.IO;
using System.Net;
using System.Text;

namespace wrapper {
    class Wrapper {
        private static int readWriteTimeout = 1000 * 30;
        private static int timeout = 1000 * 30;
        private static string userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36";

        private static string getRequest(string url) {
            ServicePointManager.DefaultConnectionLimit = 100;
            var request = (HttpWebRequest)WebRequest.Create(url);
            if (url.StartsWith("https://")) ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;
            request.ContentType = "text/plain; charset=utf-8";
            request.Timeout = timeout;
            request.ReadWriteTimeout = readWriteTimeout;
            request.KeepAlive = false;
            request.Method = "GET";
            request.UserAgent = userAgent;
            var responseStream = request.GetResponse().GetResponseStream();
            return responseStream == null ? "" : new StreamReader(responseStream).ReadToEnd();
        }

        private static string postRequest(string url, string parameters) {
            ServicePointManager.DefaultConnectionLimit = 100;
            var request = (HttpWebRequest)WebRequest.Create(url);
            if (url.StartsWith("https://")) ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;
            request.ContentType = "application/x-www-form-urlencoded";
            request.ReadWriteTimeout = readWriteTimeout;
            request.Timeout = timeout;
            request.KeepAlive = false;
            request.Method = "POST";
            request.UserAgent = userAgent;
            var encoding = Encoding.GetEncoding("utf-8");
            var data = encoding.GetBytes(parameters);
            request.GetRequestStream().Write(data, 0, data.Length);
            var responseStream = request.GetResponse().GetResponseStream();
            return responseStream == null ? "" : new StreamReader(responseStream).ReadToEnd();
        }

        static void Main(string[] args) {
            if (args.Length < 2) {
                return;                
            }
            var m = args[0];
            var u = args[1];
            switch (m) {
                case "GET":
                    Console.WriteLine(getRequest(u));
                    break;
                case "POST":
                    var p = "";
                    try { p = args[2]; } catch (Exception e) { }
                    Console.WriteLine(postRequest(u, p));
                    break;
            }
        }
    }
}
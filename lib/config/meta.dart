class Meta {
  static const String luciLoginPath = "/cgi-bin/luci/";

  static const String dbName = "easywrt_db";
  static const int dbVersion = 1;

  static const Map<String, double> compactWindowSize = {'width': 600, 'height': 480};
  static const Map<String, double> mediumWindowSize = {'width': 840, 'height': 900};

  static const headers = {
    'Accept': '*/*',
    'Accept-Language': 'en-US,en;q=0.9,ja;q=0.8,zh-CN;q=0.7,zh;q=0.6',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
    'Content-Type': 'application/json',
    'Pragma': 'no-cache',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',
  };
}
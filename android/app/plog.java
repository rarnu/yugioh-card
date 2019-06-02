LogConfig config = PLogConfig.newBuilder()
                .emptyMsg("empty log")
                .emptyMsgLevel(Log.VERBOSE)
                .globalStackOffset(1)
                .needLineNumber(QkAppProps.isDebugMode())
                .needThreadInfo(true)
                .useAutoTag(true)
                .globalTag(LogUtils.TAG)
                .build();
        DebugPrinter debugPrinter = new DebugPrinter(QkAppProps.isDebugMode());
        debugPrinter.setStyle(new LogFileStyle());
        PLog.prepare(debugPrinter);
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                == PackageManager.PERMISSION_GRANTED) {
            LocaleTimeTask.getInstance().postRunnerNeedTime(new Runnable() {
                @Override
                public void run() {
                    String mLogFilePath = LogUtils.getLogFilePath(
                            LocaleTimeTask.getInstance().currentTimeOrLocale());
                    //NormalLogPrinter
                    QKLogInterceptor interceptor = new QKLogInterceptor();
                    interceptor.addInterceptors(new HttpLogInterceptor());
                    interceptor.addInterceptors(new FileLogInterceptor());
                    QKLogFilePrinter qkLogFilePrinter = new LogFileBuilder()
                            .setDir(mLogFilePath)
                            .setFileNameGenerator(new LogFileNameGenerator())
                            .setLimit(10 * 1024 * 1024)
                            .setInterceptor(interceptor)
                            .setStyle(new LogFileStyle())
                            .build();
                    if (qkLogFilePrinter != null)
                        PLog.appendPrinter(qkLogFilePrinter);
                }
            });
        }
        PLog.init(config);
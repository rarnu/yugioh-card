package com.rarnu.yugioh;

public class NativeAPI {
    static {
        System.loadLibrary("yugiohapi");
    }

    public static native String cardSearch(
        String aname, 
        String ajapname, 
        String aenname,
        String arace,
        String aelement,
        String aatk,
        String adef,
        String alevel,
        String apendulum,
        String alink,
        String alinkarrow,
        String acardtype,
        String acardtype2,
        String aeffect,
        int apage);
}

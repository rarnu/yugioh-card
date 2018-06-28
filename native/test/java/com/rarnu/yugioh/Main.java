package com.rarnu.yugioh;

public class Main {

    public static void main(String[] args) {
        String ret = NativeAPI.cardSearch("", "", "", "", "", "0", "0", "8", "", "", "", "", "", "", 1);
        System.out.println(ret);
    }
}

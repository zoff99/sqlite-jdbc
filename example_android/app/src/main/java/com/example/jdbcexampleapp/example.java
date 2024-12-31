package com.example.jdbcexampleapp;

import android.content.Context;

@SuppressWarnings("ALL")
public class example
{
    private String path;
    private final String TAG = "JDBC-Example:";

    String testme(Context c)
    {
        System.out.println(TAG + "starting ...");
        String ret = "\nstarting ...";

        // define the path where the vfs container file will be located
        path = c.getExternalFilesDir(null).getAbsolutePath() + "/" + "text" + ".db";

        // here we need java.io.* classes since the container file is a "real" file
        java.io.File db = new java.io.File(path);

        // all finished
        System.out.println(TAG + "finished.");
        ret = ret + "\n" + "finished";

        return ret;
    }
}

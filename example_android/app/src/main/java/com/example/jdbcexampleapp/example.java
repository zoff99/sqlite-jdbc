package com.example.jdbcexampleapp;

import android.content.Context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

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

        /*
            UnsatisfiedLinkError: dlopen failed: cannot locate symbol "RAND_bytes" referenced by
            "/lib/x86_64/libsqlitejdbc.so"
         */
        System.loadLibrary("sqlitejdbc");

        Connection connection = null;
        try
        {
            connection = DriverManager.getConnection("jdbc:sqlite:sample.db");
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }
        try
        {
            Statement statement = connection.createStatement();
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }

        // all finished
        System.out.println(TAG + "finished.");
        ret = ret + "\n" + "finished";

        return ret;
    }
}

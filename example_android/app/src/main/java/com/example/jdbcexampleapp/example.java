package com.example.jdbcexampleapp;

import android.content.Context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@SuppressWarnings("ALL")
public class example
{
    private String path;
    private final String TAG = "JDBC-Example:";
    private final String good_password = "pass123iesj,ä0p23.oe jiwayä,wsyäysä9 wrr jäsäökfs poö$§&";
    private static Connection connection = null;
    private static String ret = "";

    /*
     * Runs SQL statements that are seperated by ";" character
     */
    public static void run_multi_sql(String sql_multi)
    {
        try
        {
            Statement statement = null;

            try
            {
                statement = connection.createStatement();
                statement.setQueryTimeout(10);  // set timeout to x sec.
            }
            catch (SQLException e)
            {
                System.err.println(e.getMessage());
            }

            String[] queries = sql_multi.split(";");
            for (String query : queries)
            {
                try
                {
                    System.out.println("SQL:" + query);
                    statement.executeUpdate(query);
                }
                catch (SQLException e)
                {
                    System.err.println(e.getMessage());
                }
            }

            try
            {
                statement.close();
            }
            catch (Exception e)
            {
                System.err.println(e.getMessage());
            }
        }
        catch (Exception e)
        {
            System.err.println(e.getMessage());
        }
    }


    String testme(Context c)
    {
        System.out.println(TAG + "starting ...");
        ret = "\nstarting ...";

        // define the path where the vfs container file will be located
        path = c.getExternalFilesDir(null).getAbsolutePath() + "/" + "text" + ".db";

        // here we need java.io.* classes since the container file is a "real" file
        java.io.File db = new java.io.File(path);

        try
        {
            String class_sqlite = String.valueOf(Class.forName("org.sqlite.JDBC"));
            System.out.println(TAG + class_sqlite);
            ret = ret + "\n" + class_sqlite;
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }

        System.out.println(TAG + "open DB");
        ret = ret + "\n" +  "open DB";
        open_db(good_password, true);

        boolean db_open = check_db_open();
        if (!db_open)
        {
            System.out.println(TAG + "error opening DB");
            ret = ret + "\n" + "error opening DB";
        }

        try
        {
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(
                    "select db_version from orma_schema order by db_version desc limit 1");
            if (rs.next())
            {
                int ret2 = rs.getInt("db_version");
                System.out.println(TAG + "db_version: " + ret2);
                ret = ret + "\n" +  "db_version: " + ret2;
            }

            try
            {
                statement.close();
            }
            catch (Exception ignored)
            {
            }
        }
        catch (Exception e)
        {
            try
            {
                final String update_001 = "CREATE TABLE orma_schema (db_version INTEGER NOT NULL);";
                run_multi_sql(update_001);
                final String update_002 = "insert into orma_schema values ('0');";
                run_multi_sql(update_002);
            }
            catch (Exception e2)
            {
                e2.printStackTrace();
            }
        }

        try
        {
            connection.close();
        }
        catch (Exception ex)
        {
            throw new RuntimeException(ex);
        }


        // close DB
        System.out.println(TAG + "close DB.");
        ret = ret + "\n" + "close DB";

        // delete DB
        db.delete();
        System.out.println(TAG + "delete DB.");
        ret = ret + "\n" + "delete DB";

        // reopen DB with correct key
        System.out.println(TAG + "reopen DB");
        ret = ret + "\n" +  "reopen DB";
        open_db(good_password, true);

        boolean db_reopen = check_db_open();
        if (!db_reopen)
        {
            System.out.println(TAG + "error re-opening DB");
            ret = ret + "\n" + "error re-opening DB";
        }

        // close DB
        System.out.println(TAG + "close again DB.");
        ret = ret + "\n" + "close again DB";

        // all finished
        System.out.println(TAG + "finished.");
        ret = ret + "\n" + "finished";

        return ret;
    }

    private boolean check_db_open()
    {
        boolean ret2 = false;
        try
        {
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(
                    "SELECT count(*) as sqlite_master_count FROM sqlite_master");
            if (rs.next())
            {
                long ret3 = rs.getLong("sqlite_master_count");
                System.out.println(TAG + "sqlite_master_count: " + ret3);
                ret = ret + "\n" + "sqlite_master_count: " + ret3;
                ret2 = true;
            }

            try
            {
                statement.close();
            }
            catch (Exception ignored)
            {
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            System.out.println(TAG + "DBERR: database could not be opened!!");
            ret = ret + "\n" + "DBERR: database could not be opened!!";
        }
        return ret2;
    }

    private void open_db(final String password, boolean wal_mode)
    {
        try
        {
            connection = DriverManager.getConnection("jdbc:sqlite:" + path);
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }

        // set password
        final String set_key = "PRAGMA key = '" + password + "';";
        run_multi_sql(set_key);
        ret = ret + "\n" + "set password";

        if  (wal_mode)
        {
            // set WAL mode
            final String set_wal_mode = "PRAGMA journal_mode = WAL;";
            run_multi_sql(set_wal_mode);
            ret = ret + "\n" + "set WAL mode";
        }
    }
}

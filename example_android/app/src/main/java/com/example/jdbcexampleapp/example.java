package com.example.jdbcexampleapp;

import android.content.Context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
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
    private static boolean thread_read_stop = false;
    private static boolean use_wal_mode = true;
    private static final int num_inserts = 1000;
    private static final int num_threads_write = 5;
    private static final int num_threads_read = 10;

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

    long count_gm(boolean log, String tnum_str)
    {
        long count = 0L;
        try
        {
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(
                    "select count(*) as count from GroupMessage");
            if (rs.next())
            {
                count = rs.getLong("count");
                if (log)
                {
                    System.out.println(TAG + tnum_str + ":count: " + count);
                    ret = ret + "\n" + "count: " + count;
                }
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
        }

        return count;
    }

    void insert_gm_single()
    {
        String insert_pstmt_sql = null;
        PreparedStatement insert_pstmt = null;

        // @formatter:off
        insert_pstmt_sql ="insert into GroupMessage " +
                          "("
                          + "message_id_tox"
                          + ",group_identifier"
                          + ",tox_group_peer_pubkey"
                          + ",tox_group_peer_role"
                          + ",private_message"
                          + ",tox_group_peername"
                          + ",direction"
                          + ",TOX_MESSAGE_TYPE"
                          + ",TRIFA_MESSAGE_TYPE"
                          + ",sent_timestamp"
                          + ",rcvd_timestamp"
                          + ",read"
                          + ",is_new"
                          + ",text"
                          + ",was_synced"
                          + ",TRIFA_SYNC_TYPE"
                          + ",sync_confirmations"
                          + ",tox_group_peer_pubkey_syncer_01"
                          + ",tox_group_peer_pubkey_syncer_02"
                          + ",tox_group_peer_pubkey_syncer_03"
                          + ",tox_group_peer_pubkey_syncer_01_sent_timestamp"
                          + ",tox_group_peer_pubkey_syncer_02_sent_timestamp"
                          + ",tox_group_peer_pubkey_syncer_03_sent_timestamp"
                          + ",msg_id_hash"
                          + ",sent_privately_to_tox_group_peer_pubkey"
                          + ",path_name"
                          + ",file_name"
                          + ",filename_fullpath"
                          + ",filesize"
                          + ",storage_frame_work"
                          + ")" +
                          "values" +
                          "("
                          + "?1"
                          + ",?2"
                          + ",?3"
                          + ",?4"
                          + ",?5"
                          + ",?6"
                          + ",?7"
                          + ",?8"
                          + ",?9"
                          + ",?10"
                          + ",?11"
                          + ",?12"
                          + ",?13"
                          + ",?14"
                          + ",?15"
                          + ",?16"
                          + ",?17"
                          + ",?18"
                          + ",?19"
                          + ",?20"
                          + ",?21"
                          + ",?22"
                          + ",?23"
                          + ",?24"
                          + ",?25"
                          + ",?26"
                          + ",?27"
                          + ",?28"
                          + ",?29"
                          + ",?30"
                          + ")";

        try
        {
            insert_pstmt = connection.prepareStatement(insert_pstmt_sql);
            insert_pstmt.clearParameters();

            insert_pstmt.setString(1, "this.message_id_tox");
            insert_pstmt.setString(2, "this.group_identifier");
            insert_pstmt.setString(3, "this.tox_group_peer_pubkey");
            insert_pstmt.setInt(4, 1);
            insert_pstmt.setInt(5, 1);
            insert_pstmt.setString(6, "this.tox_group_peername");
            insert_pstmt.setInt(7, 1);
            insert_pstmt.setInt(8, 1);
            insert_pstmt.setInt(9, 1);
            insert_pstmt.setLong(10, 20000000000000000L);
            insert_pstmt.setLong(11, 20000000000000000L);
            insert_pstmt.setBoolean(12, true);
            insert_pstmt.setBoolean(13, true);
            insert_pstmt.setString(14, "this.text");
            insert_pstmt.setBoolean(15, true);
            insert_pstmt.setInt(16, 1);
            insert_pstmt.setInt(17, 1);
            insert_pstmt.setString(18, "this.tox_group_peer_pubkey_syncer_01");
            insert_pstmt.setString(19, "this.tox_group_peer_pubkey_syncer_02");
            insert_pstmt.setString(20, "this.tox_group_peer_pubkey_syncer_03");
            insert_pstmt.setLong(21, 20000000000000000L);
            insert_pstmt.setLong(22, 20000000000000000L);
            insert_pstmt.setLong(23, 20000000000000000L);
            insert_pstmt.setString(24, "this.msg_id_hash");
            insert_pstmt.setString(25, "this.sent_privately_to_tox_group_peer_pubkey");
            insert_pstmt.setString(26, "this.path_name");
            insert_pstmt.setString(27, "this.file_name");
            insert_pstmt.setString(28, "this.filename_fullpath");
            insert_pstmt.setLong(29, 20000000000000000L);
            insert_pstmt.setBoolean(30, true);
        }
        catch (SQLException e)
        {
            throw new RuntimeException(e);
        }

        try
        {
            insert_pstmt.executeUpdate();
            insert_pstmt.close();
        }
        catch (SQLException e)
        {
            throw new RuntimeException(e);
        }
    }

    Thread read_gm_thread(int tnum)
    {
        Thread thread = new Thread() {
            public void run() {
                try
                {
                    while (!thread_read_stop)
                    {
                        count_gm(false, "R_"+tnum);
                        // Thread.sleep((long)(Math.random() * 20.0f));
                        Thread.sleep(10);
                    }
                }
                catch (Exception e)
                {
                }
            }
        };

        thread.start();
        return thread;
    }

    Thread insert_gm_thread(int tnum)
    {
        Thread thread = new Thread() {
            public void run() {
                try
                {
                    for (int i=0;i<num_inserts;i++)
                    {
                        insert_gm_single();
                        count_gm(false, "w_" + tnum);
                        // Thread.sleep((long)(Math.random() * 20.0f));
                        Thread.sleep(5);
                    }
                }
                catch (Exception e)
                {
                }
            }
        };

        thread.start();
        return thread;
    }

    String testme(Context c)
    {
        System.out.println(TAG + "starting ...");
        ret = "\nstarting ...";

        // define the path where the vfs container file will be located
        // path = c.getExternalFilesDir(null).getAbsolutePath() + "/" + "text" + ".db";
        path = "/data/data/com.example.jdbcexampleapp/files/" + "text2.db";

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
        open_db(good_password, use_wal_mode);

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
        open_db(good_password, use_wal_mode);

        boolean db_reopen = check_db_open();
        if (!db_reopen)
        {
            System.out.println(TAG + "error re-opening DB");
            ret = ret + "\n" + "error re-opening DB";
        }





        // pounding test ----------------
        try
        {
            final String update_001 = "CREATE TABLE IF NOT EXISTS \"GroupMessage\" (\n" + "  \"id\" INTEGER,\n" +
                                      "  \"message_id_tox\" TEXT,\n" + "  \"group_identifier\" TEXT,\n" +
                                      "  \"tox_group_peer_pubkey\" TEXT,\n" + "  \"tox_group_peer_role\" INTEGER,\n" +
                                      "  \"private_message\" INTEGER,\n" + "  \"tox_group_peername\" TEXT,\n" +
                                      "  \"direction\" INTEGER,\n" + "  \"TOX_MESSAGE_TYPE\" INTEGER,\n" +
                                      "  \"TRIFA_MESSAGE_TYPE\" INTEGER,\n" + "  \"sent_timestamp\" INTEGER,\n" +
                                      "  \"rcvd_timestamp\" INTEGER,\n" + "  \"read\" BOOLEAN,\n" +
                                      "  \"is_new\" BOOLEAN,\n" + "  \"text\" TEXT,\n" + "  \"was_synced\" BOOLEAN,\n" +
                                      "  \"TRIFA_SYNC_TYPE\" INTEGER,\n" + "  \"sync_confirmations\" INTEGER,\n" +
                                      "  \"tox_group_peer_pubkey_syncer_01\" TEXT,\n" +
                                      "  \"tox_group_peer_pubkey_syncer_02\" TEXT,\n" +
                                      "  \"tox_group_peer_pubkey_syncer_03\" TEXT,\n" +
                                      "  \"tox_group_peer_pubkey_syncer_01_sent_timestamp\" INTEGER,\n" +
                                      "  \"tox_group_peer_pubkey_syncer_02_sent_timestamp\" INTEGER,\n" +
                                      "  \"tox_group_peer_pubkey_syncer_03_sent_timestamp\" INTEGER,\n" +
                                      "  \"msg_id_hash\" TEXT,\n" +
                                      "  \"sent_privately_to_tox_group_peer_pubkey\" TEXT,\n" +
                                      "  \"path_name\" TEXT,\n" + "  \"file_name\" TEXT,\n" +
                                      "  \"filename_fullpath\" TEXT,\n" + "  \"filesize\" INTEGER,\n" +
                                      "  \"storage_frame_work\" BOOLEAN,\n" + "  PRIMARY KEY(\"id\" AUTOINCREMENT)\n" +
                                      ");\n" + "\n";
            run_multi_sql(update_001);
            System.out.println(TAG + "CREATE TABLE GroupMessage");
            ret = ret + "\n" + "CREATE TABLE GroupMessage";
        }
        catch (Exception e2)
        {
            e2.printStackTrace();
        }

        System.out.println(TAG + "number of inserts: " + (num_inserts * num_threads_write));

        Thread[] t = new Thread[num_threads_write];
        for (int i=0;i<num_threads_write;i++)
        {
            t[i] = insert_gm_thread(i);
        }
        count_gm(true, "main");

        thread_read_stop = false;
        Thread[] tr = new Thread[num_threads_read];
        for (int i=0;i<num_threads_read;i++)
        {
            tr[i] = read_gm_thread(i);
        }

        for (int i=0;i<num_threads_write;i++)
        {
            try
            {
                t[i].join();
            }
            catch (InterruptedException e)
            {
                throw new RuntimeException(e);
            }
        }
        thread_read_stop = true;

        count_gm(true, "main");
        // pounding test ----------------



        // close DB
        System.out.println(TAG + "close again DB.");
        ret = ret + "\n" + "close again DB";

        try
        {
            connection.close();
        }
        catch (Exception ex)
        {
            throw new RuntimeException(ex);
        }

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

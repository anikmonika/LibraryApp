package com.example.simplelibrary.data;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import com.example.simplelibrary.data.dao.BookDao;
import com.example.simplelibrary.data.dao.LoanDao;
import com.example.simplelibrary.data.dao.MemberDao;
import com.example.simplelibrary.data.entity.Book;
import com.example.simplelibrary.data.entity.Loan;
import com.example.simplelibrary.data.entity.Member;

@Database(entities = {Book.class, Member.class, Loan.class}, version = 1, exportSchema = false)
public abstract class AppDatabase extends RoomDatabase {

    private static volatile AppDatabase INSTANCE;

    public abstract BookDao bookDao();
    public abstract MemberDao memberDao();
    public abstract LoanDao loanDao();

    public static AppDatabase getInstance(Context context) {
        if (INSTANCE == null) {
            synchronized (AppDatabase.class) {
                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context.getApplicationContext(),
                                    AppDatabase.class, "simple_library.db")
                            .allowMainThreadQueries() // keep simple for coursework; production should use background threads
                            .build();
                }
            }
        }
        return INSTANCE;
    }
}

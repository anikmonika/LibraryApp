package com.example.simplelibrary.data.dao;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Update;

import com.example.simplelibrary.data.entity.Book;

import java.util.List;

@Dao
public interface BookDao {

    @Query("SELECT * FROM books ORDER BY title ASC")
    LiveData<List<Book>> observeAll();

    @Query("SELECT * FROM books WHERE title LIKE '%' || :q || '%' OR author LIKE '%' || :q || '%' ORDER BY title ASC")
    LiveData<List<Book>> observeSearch(String q);

    @Query("SELECT * FROM books WHERE title = :title LIMIT 1")
    Book findByTitle(String title);

    @Query("SELECT * FROM books WHERE id = :id LIMIT 1")
    Book findById(long id);

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    long insert(Book book);

    @Update
    void update(Book book);

    @Query("SELECT COUNT(*) FROM books")
    int count();
}

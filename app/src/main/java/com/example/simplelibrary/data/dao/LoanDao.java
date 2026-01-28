package com.example.simplelibrary.data.dao;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import com.example.simplelibrary.data.entity.Loan;
import com.example.simplelibrary.data.dto.LoanRow;

import java.util.List;

@Dao
public interface LoanDao {

    @Query("SELECT loans.id AS loanId, members.name AS memberName, books.title AS bookTitle, " +
            "loans.borrowDateMillis AS borrowDateMillis, loans.dueDateMillis AS dueDateMillis, loans.returned AS returned " +
            "FROM loans " +
            "JOIN members ON members.id = loans.memberId " +
            "JOIN books ON books.id = loans.bookId " +
            "ORDER BY loans.borrowDateMillis DESC")
    LiveData<List<LoanRow>> observeAllRows();

    @Insert
    long insert(Loan loan);

    @Update
    void update(Loan loan);

    @Query("SELECT * FROM loans WHERE id = :loanId LIMIT 1")
    Loan findById(long loanId);
}

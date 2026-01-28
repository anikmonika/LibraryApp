package com.example.simplelibrary.data.dao;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import com.example.simplelibrary.data.entity.Member;

@Dao
public interface MemberDao {

    @Query("SELECT * FROM members WHERE name = :name LIMIT 1")
    Member findByName(String name);

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    long insert(Member member);
}

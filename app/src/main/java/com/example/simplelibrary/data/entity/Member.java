package com.example.simplelibrary.data.entity;

import androidx.room.Entity;
import androidx.room.Index;
import androidx.room.PrimaryKey;

@Entity(tableName = "members", indices = {@Index(value = {"name"}, unique = true)})
public class Member {

    @PrimaryKey(autoGenerate = true)
    public long id;

    public String name;

    public Member(String name) {
        this.name = name;
    }
}

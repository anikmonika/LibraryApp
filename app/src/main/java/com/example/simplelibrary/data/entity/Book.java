package com.example.simplelibrary.data.entity;

import androidx.room.Entity;
import androidx.room.Index;
import androidx.room.PrimaryKey;

@Entity(tableName = "books", indices = {@Index(value = {"title"}, unique = true)})
public class Book {

    @PrimaryKey(autoGenerate = true)
    public long id;

    public String title;
    public String author;
    public int year;
    public int totalCopies;
    public int availableCopies;

    public Book(String title, String author, int year, int totalCopies, int availableCopies) {
        this.title = title;
        this.author = author;
        this.year = year;
        this.totalCopies = totalCopies;
        this.availableCopies = availableCopies;
    }
}

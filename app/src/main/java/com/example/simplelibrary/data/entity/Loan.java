package com.example.simplelibrary.data.entity;

import androidx.room.Entity;
import androidx.room.ForeignKey;
import androidx.room.Index;
import androidx.room.PrimaryKey;

@Entity(
        tableName = "loans",
        foreignKeys = {
                @ForeignKey(entity = Member.class, parentColumns = "id", childColumns = "memberId", onDelete = ForeignKey.CASCADE),
                @ForeignKey(entity = Book.class, parentColumns = "id", childColumns = "bookId", onDelete = ForeignKey.RESTRICT)
        },
        indices = {@Index("memberId"), @Index("bookId")}
)
public class Loan {

    @PrimaryKey(autoGenerate = true)
    public long id;

    public long memberId;
    public long bookId;

    public long borrowDateMillis;
    public long dueDateMillis;

    public boolean returned;

    public Loan(long memberId, long bookId, long borrowDateMillis, long dueDateMillis, boolean returned) {
        this.memberId = memberId;
        this.bookId = bookId;
        this.borrowDateMillis = borrowDateMillis;
        this.dueDateMillis = dueDateMillis;
        this.returned = returned;
    }
}

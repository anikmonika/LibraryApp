package com.example.simplelibrary.data.dto;

public class LoanRow {
    public long loanId;
    public String memberName;
    public String bookTitle;
    public long borrowDateMillis;
    public long dueDateMillis;
    public boolean returned;
}

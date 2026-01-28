package com.example.simplelibrary.ui.staff;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;

import com.example.simplelibrary.data.LibraryRepository;
import com.example.simplelibrary.data.dto.LoanRow;
import com.example.simplelibrary.ui.common.RepositoryProvider;

import java.util.List;

public class LoansViewModel extends AndroidViewModel {

    private final LibraryRepository repo;

    public LoansViewModel(@NonNull Application application) {
        super(application);
        repo = RepositoryProvider.get(application);
    }

    public LiveData<List<LoanRow>> loans() {
        return repo.observeLoans();
    }

    public String createLoan(String memberName, String bookTitle) {
        return repo.createLoan(memberName, bookTitle);
    }

    public String markReturned(long loanId) {
        return repo.markReturned(loanId);
    }
}

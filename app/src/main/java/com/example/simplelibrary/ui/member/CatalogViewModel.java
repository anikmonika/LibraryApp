package com.example.simplelibrary.ui.member;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;

import com.example.simplelibrary.data.LibraryRepository;
import com.example.simplelibrary.data.entity.Book;
import com.example.simplelibrary.ui.common.RepositoryProvider;

import java.util.List;

public class CatalogViewModel extends AndroidViewModel {

    private final LibraryRepository repo;

    public CatalogViewModel(@NonNull Application application) {
        super(application);
        repo = RepositoryProvider.get(application);
    }

    public LiveData<List<Book>> catalog(String query) {
        return repo.observeCatalog(query);
    }
}

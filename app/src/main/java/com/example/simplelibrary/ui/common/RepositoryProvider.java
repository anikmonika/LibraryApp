package com.example.simplelibrary.ui.common;

import android.content.Context;

import com.example.simplelibrary.data.LibraryRepository;

public final class RepositoryProvider {

    private static volatile LibraryRepository INSTANCE;

    private RepositoryProvider() {}

    public static LibraryRepository get(Context context) {
        if (INSTANCE == null) {
            synchronized (RepositoryProvider.class) {
                if (INSTANCE == null) {
                    INSTANCE = new LibraryRepository(context.getApplicationContext());
                }
            }
        }
        return INSTANCE;
    }
}

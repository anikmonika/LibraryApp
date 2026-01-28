package com.example.simplelibrary.ui.member;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;

import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.simplelibrary.R;
import com.google.android.material.textfield.TextInputEditText;

public class MemberHomeActivity extends AppCompatActivity {

    private CatalogViewModel vm;
    private BookAdapter adapter;
    private TextInputEditText etSearch;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_member_home);

        vm = new ViewModelProvider(this).get(CatalogViewModel.class);

        RecyclerView rv = findViewById(R.id.rvBooks);
        rv.setLayoutManager(new LinearLayoutManager(this));
        adapter = new BookAdapter();
        rv.setAdapter(adapter);

        etSearch = findViewById(R.id.etSearch);
        etSearch.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
            @Override public void onTextChanged(CharSequence s, int start, int before, int count) { load(s.toString()); }
            @Override public void afterTextChanged(Editable s) {}
        });

        load("");
    }

    private void load(String query) {
        vm.catalog(query).observe(this, books -> adapter.submit(books));
    }
}

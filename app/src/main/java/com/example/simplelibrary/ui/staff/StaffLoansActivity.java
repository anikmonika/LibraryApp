package com.example.simplelibrary.ui.staff;

import android.app.AlertDialog;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.simplelibrary.R;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;

public class StaffLoansActivity extends AppCompatActivity {

    private LoansViewModel vm;
    private LoanAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_staff_loans);

        vm = new ViewModelProvider(this).get(LoansViewModel.class);

        RecyclerView rv = findViewById(R.id.rvLoans);
        rv.setLayoutManager(new LinearLayoutManager(this));
        adapter = new LoanAdapter(loanId -> {
            String err = vm.markReturned(loanId);
            if (err != null) Toast.makeText(this, err, Toast.LENGTH_SHORT).show();
        });
        rv.setAdapter(adapter);

        vm.loans().observe(this, rows -> adapter.submit(rows));

        MaterialButton btnAdd = findViewById(R.id.btnAdd);
        btnAdd.setOnClickListener(v -> showAddDialog());
    }

    private void showAddDialog() {
        View form = LayoutInflater.from(this).inflate(R.layout.dialog_add_loan, null, false);
        TextInputEditText etMember = form.findViewById(R.id.etMemberName);
        TextInputEditText etBook = form.findViewById(R.id.etBookTitle);

        new AlertDialog.Builder(this)
                .setTitle(getString(R.string.add_loan))
                .setView(form)
                .setPositiveButton("Simpan", (d, which) -> {
                    String err = vm.createLoan(
                            etMember.getText() == null ? "" : etMember.getText().toString(),
                            etBook.getText() == null ? "" : etBook.getText().toString()
                    );
                    if (err != null) Toast.makeText(this, err, Toast.LENGTH_SHORT).show();
                    else Toast.makeText(this, "Peminjaman tersimpan.", Toast.LENGTH_SHORT).show();
                })
                .setNegativeButton("Batal", null)
                .show();
    }
}

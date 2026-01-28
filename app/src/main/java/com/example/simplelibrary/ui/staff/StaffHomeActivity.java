package com.example.simplelibrary.ui.staff;

import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.example.simplelibrary.R;
import com.example.simplelibrary.ui.member.MemberHomeActivity;
import com.google.android.material.button.MaterialButton;

public class StaffHomeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_staff_home);

        MaterialButton btnCatalog = findViewById(R.id.btnCatalog);
        MaterialButton btnLoans = findViewById(R.id.btnLoans);

        btnCatalog.setOnClickListener(v -> startActivity(new Intent(this, MemberHomeActivity.class)));
        btnLoans.setOnClickListener(v -> startActivity(new Intent(this, StaffLoansActivity.class)));
    }
}

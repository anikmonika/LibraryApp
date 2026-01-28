package com.example.simplelibrary.ui;

import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.example.simplelibrary.R;
import com.example.simplelibrary.ui.member.MemberHomeActivity;
import com.example.simplelibrary.ui.staff.StaffHomeActivity;
import com.google.android.material.button.MaterialButton;

public class RoleSelectActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_role_select);

        MaterialButton btnMember = findViewById(R.id.btnMember);
        MaterialButton btnStaff = findViewById(R.id.btnStaff);

        btnMember.setOnClickListener(v -> startActivity(new Intent(this, MemberHomeActivity.class)));
        btnStaff.setOnClickListener(v -> startActivity(new Intent(this, StaffHomeActivity.class)));
    }
}

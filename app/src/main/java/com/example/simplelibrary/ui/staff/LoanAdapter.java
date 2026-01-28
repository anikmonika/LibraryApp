package com.example.simplelibrary.ui.staff;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.simplelibrary.R;
import com.example.simplelibrary.data.dto.LoanRow;
import com.example.simplelibrary.util.DateUtils;
import com.google.android.material.button.MaterialButton;

import java.util.ArrayList;
import java.util.List;

public class LoanAdapter extends RecyclerView.Adapter<LoanAdapter.VH> {

    public interface OnReturnClick {
        void onReturn(long loanId);
    }

    private final List<LoanRow> items = new ArrayList<>();
    private final OnReturnClick onReturnClick;

    public LoanAdapter(OnReturnClick onReturnClick) {
        this.onReturnClick = onReturnClick;
    }

    public void submit(List<LoanRow> data) {
        items.clear();
        if (data != null) items.addAll(data);
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public VH onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_loan, parent, false);
        return new VH(v);
    }

    @Override
    public void onBindViewHolder(@NonNull VH holder, int position) {
        LoanRow r = items.get(position);

        String prefix = "";
        boolean overdue = !r.returned && DateUtils.isOverdue(r.dueDateMillis, DateUtils.nowMillis());
        if (overdue) prefix = "OVERDUE • ";

        holder.tvBorrower.setText(prefix + r.memberName);
        holder.tvDetail.setText(
                "Buku: " + r.bookTitle +
                "\nPinjam: " + DateUtils.formatDate(r.borrowDateMillis) +
                "\nJatuh tempo: " + DateUtils.formatDate(r.dueDateMillis) +
                "\nStatus: " + (r.returned ? "Kembali" : "Dipinjam")
        );

        holder.btnReturn.setEnabled(!r.returned);
        holder.btnReturn.setOnClickListener(v -> onReturnClick.onReturn(r.loanId));
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    static class VH extends RecyclerView.ViewHolder {
        TextView tvBorrower;
        TextView tvDetail;
        MaterialButton btnReturn;

        VH(@NonNull View itemView) {
            super(itemView);
            tvBorrower = itemView.findViewById(R.id.tvBorrower);
            tvDetail = itemView.findViewById(R.id.tvDetail);
            btnReturn = itemView.findViewById(R.id.btnReturn);
        }
    }
}

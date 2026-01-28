package com.example.simplelibrary.data;

import android.content.Context;

import androidx.lifecycle.LiveData;

import com.example.simplelibrary.data.dao.BookDao;
import com.example.simplelibrary.data.dao.LoanDao;
import com.example.simplelibrary.data.dao.MemberDao;
import com.example.simplelibrary.data.dto.LoanRow;
import com.example.simplelibrary.data.entity.Book;
import com.example.simplelibrary.data.entity.Loan;
import com.example.simplelibrary.data.entity.Member;
import com.example.simplelibrary.util.DateUtils;

import java.util.List;

/**
 * Repository = satu tempat untuk semua operasi data.
 * Untuk menjaga aplikasi tugas tetap simple, operasi DB dibuat synchronous.
 * (Di produksi, pakai Executor/Coroutine/Rx + proper thread management.)
 */
public class LibraryRepository {

    private final BookDao bookDao;
    private final MemberDao memberDao;
    private final LoanDao loanDao;

    public LibraryRepository(Context context) {
        AppDatabase db = AppDatabase.getInstance(context);
        this.bookDao = db.bookDao();
        this.memberDao = db.memberDao();
        this.loanDao = db.loanDao();
        seedIfEmpty();
    }

    public LiveData<List<Book>> observeCatalog(String query) {
        if (query == null || query.trim().isEmpty()) {
            return bookDao.observeAll();
        }
        return bookDao.observeSearch(query.trim());
    }

    public LiveData<List<LoanRow>> observeLoans() {
        return loanDao.observeAllRows();
    }

    /**
     * Catat peminjaman: 1 anggota meminjam 1 buku per transaksi (biar simple).
     * Due date otomatis = 7 hari dari tanggal pinjam.
     *
     * @return null jika sukses, atau pesan error jika gagal
     */
    public String createLoan(String memberName, String bookTitle) {
        if (memberName == null || memberName.trim().isEmpty()) return "Nama anggota wajib diisi.";
        if (bookTitle == null || bookTitle.trim().isEmpty()) return "Judul buku wajib diisi.";

        Member member = memberDao.findByName(memberName.trim());
        if (member == null) {
            long newId = memberDao.insert(new Member(memberName.trim()));
            member = memberDao.findByName(memberName.trim());
            if (member == null) return "Gagal membuat data anggota.";
            if (newId > 0) member.id = newId;
        }

        Book book = bookDao.findByTitle(bookTitle.trim());
        if (book == null) return "Buku tidak ditemukan di katalog.";
        if (book.availableCopies <= 0) return "Stok buku habis (tidak tersedia).";

        long now = DateUtils.nowMillis();
        long due = DateUtils.addDays(now, 7);

        long loanId = loanDao.insert(new Loan(member.id, book.id, now, due, false));
        if (loanId <= 0) return "Gagal mencatat peminjaman.";

        book.availableCopies -= 1;
        bookDao.update(book);

        return null;
    }

    /**
     * Proses pengembalian: tandai returned=true dan stok buku bertambah.
     */
    public String markReturned(long loanId) {
        Loan loan = loanDao.findById(loanId);
        if (loan == null) return "Data peminjaman tidak ditemukan.";
        if (loan.returned) return "Sudah dikembalikan.";

        loan.returned = true;
        loanDao.update(loan);

        Book book = bookDao.findById(loan.bookId);
        if (book != null) {
            book.availableCopies += 1;
            bookDao.update(book);
        }
        return null;
    }

    private void seedIfEmpty() {
        if (bookDao.count() > 0) return;

        bookDao.insert(new Book("Clean Code", "Robert C. Martin", 2008, 3, 3));
        bookDao.insert(new Book("Effective Java", "Joshua Bloch", 2018, 2, 2));
        bookDao.insert(new Book("Head First Java", "Kathy Sierra", 2005, 2, 2));
        bookDao.insert(new Book("Android Programming", "Big Nerd Ranch", 2022, 1, 1));
    }
}

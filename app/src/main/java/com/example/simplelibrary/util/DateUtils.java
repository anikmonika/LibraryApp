package com.example.simplelibrary.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public final class DateUtils {

    private DateUtils() {}

    public static long nowMillis() {
        return System.currentTimeMillis();
    }

    public static long addDays(long fromMillis, int days) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(fromMillis);
        cal.add(Calendar.DAY_OF_YEAR, days);
        return cal.getTimeInMillis();
    }

    public static String formatDate(long millis) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy", Locale.getDefault());
        return sdf.format(new Date(millis));
    }

    public static boolean isOverdue(long dueMillis, long nowMillis) {
        return nowMillis > dueMillis;
    }
}

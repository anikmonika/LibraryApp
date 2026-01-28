package com.example.simplelibrary;

import com.example.simplelibrary.util.DateUtils;

import org.junit.Test;

import static org.junit.Assert.*;

public class DateUtilsTest {

    @Test
    public void addDays_shouldAddSevenDays() {
        long day0 = 0L;
        long day7 = DateUtils.addDays(day0, 7);
        assertEquals(7L * 24 * 60 * 60 * 1000, day7);
    }

    @Test
    public void isOverdue_shouldBeTrueWhenNowPastDue() {
        long due = 1000L;
        long now = 1001L;
        assertTrue(DateUtils.isOverdue(due, now));
    }

    @Test
    public void isOverdue_shouldBeFalseWhenNowEqualsDue() {
        long due = 1000L;
        long now = 1000L;
        assertFalse(DateUtils.isOverdue(due, now));
    }
}

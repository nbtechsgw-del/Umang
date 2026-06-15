package com.tourism.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Booking {
    private int id;
    private int userId;
    private int packageId;
    private int hotelId;
    private Timestamp bookingDate;
    private Date travelDate;
    private String status;
    private BigDecimal totalAmount;

    public Booking() {}

    public Booking(int id, int userId, int packageId, int hotelId, Timestamp bookingDate, Date travelDate, String status, BigDecimal totalAmount) {
        this.id = id;
        this.userId = userId;
        this.packageId = packageId;
        this.hotelId = hotelId;
        this.bookingDate = bookingDate;
        this.travelDate = travelDate;
        this.status = status;
        this.totalAmount = totalAmount;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getPackageId() { return packageId; }
    public void setPackageId(int packageId) { this.packageId = packageId; }

    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }

    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }

    public Date getTravelDate() { return travelDate; }
    public void setTravelDate(Date travelDate) { this.travelDate = travelDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
}
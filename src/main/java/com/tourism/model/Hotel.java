package com.tourism.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Hotel {
    private int id;
    private String hotelName;
    private String destination;
    private int stars;
    private int rating;
    private String availabilityStatus;
    private BigDecimal pricePerNight;
    private String status;
    private Timestamp createdAt;

    public Hotel() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getHotelName() { return hotelName; }
    public void setHotelName(String hotelName) { this.hotelName = hotelName; }

    public int getRating() { 
        return rating; 
    }

    public String getAvailabilityStatus() { 
        return availabilityStatus; 
    }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public int getStars() { return stars; }
    public void setStars(int stars) { this.stars = stars; }

    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
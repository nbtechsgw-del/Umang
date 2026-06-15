package com.tourism.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class TourPackage {
    private int id;
    private String packageName;
    private String destination;
    private String category;
    private String description;
    private BigDecimal price;
    private String duration;
    private String itinerary;
    private String imageUrl;
    private String status;
    private Timestamp createdAt;

    public TourPackage() {}

    public TourPackage(int id, String packageName, String destination, String category, BigDecimal price, 
                       String duration, String itinerary, String imageUrl, String status, Timestamp createdAt) {
        this.id = id;
        this.packageName = packageName;
        this.destination = destination;
        this.category = category;
        this.price = price;
        this.duration = duration;
        this.itinerary = itinerary;
        this.imageUrl = imageUrl;
        this.status = status;
        this.createdAt = createdAt;
    }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPackageName() { return packageName; }
    public void setPackageName(String packageName) { this.packageName = packageName; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getItinerary() { return itinerary; }
    public void setItinerary(String itinerary) { this.itinerary = itinerary; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
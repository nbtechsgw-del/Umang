package com.tourism.model;

import java.sql.Timestamp;

public class Feedback {
    private int id;
    private int userId;
    private String userName;
    private String category;
    private int rating;
    private int hotelId;
    private int packageId;
    private String subject;
    private String message;
    private Timestamp submissionDate;
    private String adminStatus;
    private String adminRemarks;
    
    public int getHotelId() { 
        return hotelId; }
    public void setHotelId(int hotelId) { 
        this.hotelId = hotelId; }
    public int getPackageId() { 
        return packageId; }
    public void setPackageId(int packageId) { 
        this.packageId = packageId; }
    public int getId() { 
        return id; }
    public void setId(int id) { 
        this.id = id; }
    public int getUserId() { 
        return userId; }
    public void setUserId(int userId) { 
        this.userId = userId; }
    public String getUserName() { 
        return userName; }
    public void setUserName(String userName) { 
        this.userName = userName; }
    public String getCategory() { 
        return category; }
    public void setCategory(String category) { 
        this.category = category; }
    public int getRating() { 
        return rating; }
    public void setRating(int rating) { 
        this.rating = rating; }
    public String getSubject() { 
        return subject; }
    public void setSubject(String subject) { 
        this.subject = subject; }
    public String getMessage() { 
        return message; }
    public void setMessage(String message) { 
        this.message = message; }
    public Timestamp getSubmissionDate() { 
        return submissionDate; }
    public void setSubmissionDate(Timestamp submissionDate) { 
        this.submissionDate = submissionDate; }
    public String getAdminStatus() { 
        return adminStatus; }
    public void setAdminStatus(String adminStatus) { 
        this.adminStatus = adminStatus; }
    public String getAdminRemarks() { 
        return adminRemarks; }
    public void setAdminRemarks(String adminRemarks) { 
        this.adminRemarks = adminRemarks; }
}
package com.emi.backend;

import jakarta.persistence.*;

@Entity

public class Loan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    
    private int id;

    private String name;
    private double principal;
    private double rate;
    private int time;

    private double emi;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public double getEmi() { return emi; }
    public void setEmi(double emi) { this.emi = emi; }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrincipal() { return principal; }
    public void setPrincipal(double principal) { this.principal = principal; }

    public double getRate() { return rate; }
    public void setRate(double rate) { this.rate = rate; }

    public int getTime() { return time; }
    public void setTime(int time) { this.time = time; }
}
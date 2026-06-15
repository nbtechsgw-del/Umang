package com.tourism.model;

public class Destination {
    private int id;
    private String name;
    private String stateCountry;
    private String description;

    public Destination() {}

    public Destination(String name, String stateCountry, String description) {
        this.name = name;
        this.stateCountry = stateCountry;
        this.description = description;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getStateCountry() { return stateCountry; }
    public void setStateCountry(String stateCountry) { this.stateCountry = stateCountry; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
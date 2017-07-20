/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.entities;

/**
 *
 * @author Gabriele
 */
public class Shop {
    private Integer shopId;
    private Integer userId;
    private String name;
    private String website;
    private String address;
    private Double lat;
    private Double lon;
    private String openingHours;
    private String imagePath;

    public Integer getShopId() {
        return shopId;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getWebsite() {
        return website;
    }

    public String getAddress() {
        return address;
    }

    public Double getLat() {
        return lat;
    }

    public Double getLon() {
        return lon;
    }

    public String getOpeningHours() {
        return openingHours;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setShopId(Integer shopId) {
        this.shopId = shopId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setLat(Double lat) {
        this.lat = lat;
    }

    public void setLon(Double lon) {
        this.lon = lon;
    }

    public void setOpeningHours(String openingHours) {
        this.openingHours = openingHours;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
}

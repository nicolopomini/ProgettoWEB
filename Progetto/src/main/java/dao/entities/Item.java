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
public class Item {
    private Integer itemId;
    private String name;
    private String description;
    private String category;
    private Double price;
    private Integer shopId;

    public Integer getItemId() {
        return itemId;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public String getCategory() {
        return category;
    }

    public Double getPrice() {
        return price;
    }

    public Integer getShopId() {
        return shopId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public void setShopId(Integer shopId) {
        this.shopId = shopId;
    }
}

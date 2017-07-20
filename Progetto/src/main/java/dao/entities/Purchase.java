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
public class Purchase {
    private Integer purchaseId;
    private String purchaseTime;
    private Integer userId;
    private Integer itemId;
    private Integer quantity;

    public Integer getPurchaseId() {
        return purchaseId;
    }

    public String getPurchaseTime() {
        return purchaseTime;
    }

    public Integer getUserId() {
        return userId;
    }

    public Integer getItemId() {
        return itemId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setPurchaseId(Integer purchaseId) {
        this.purchaseId = purchaseId;
    }

    public void setPurchaseTime(String purchaseTime) {
        this.purchaseTime = purchaseTime;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}

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
public class ShopReview {
    private Integer shopReviewId;
    private String reviewText;
    private String reply;
    private Integer userId;
    private Integer shopId;
    private String reviewTime;

    public Integer getShopReviewId() {
        return shopReviewId;
    }

    public String getReviewText() {
        return reviewText;
    }

    public String getReply() {
        return reply;
    }

    public Integer getUserId() {
        return userId;
    }

    public Integer getShopId() {
        return shopId;
    }

    public String getReviewTime() {
        return reviewTime;
    }

    public void setShopReviewId(Integer shopReviewId) {
        this.shopReviewId = shopReviewId;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setShopId(Integer shopId) {
        this.shopId = shopId;
    }

    public void setReviewTime(String reviewTime) {
        this.reviewTime = reviewTime;
    }
}

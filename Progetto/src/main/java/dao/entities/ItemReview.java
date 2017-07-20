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
public class ItemReview {
    private Integer itemReviewId;
    private String reviewText;
    private String reply;
    private Integer userId;
    private Integer itemId;
    private String reviewTime;

    public Integer getItemReviewId() {
        return itemReviewId;
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

    public Integer getItemId() {
        return itemId;
    }

    public String getReviewTime() {
        return reviewTime;
    }

    public void setItemReviewId(Integer itemReviewId) {
        this.itemReviewId = itemReviewId;
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

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public void setReviewTime(String reviewTime) {
        this.reviewTime = reviewTime;
    }
}

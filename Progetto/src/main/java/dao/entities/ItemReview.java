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
    private Integer score;
    private String authorName;
    private String authorSurname;

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

    public Integer getScore() {
        return score;
    }

    public String getAuthorName() {
        return authorName;
    }

    public String getAuthorSurname() {
        return authorSurname;
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

    public void setScore(Integer score) {
        this.score = score;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public void setAuthorSurname(String authorSurname) {
        this.authorSurname = authorSurname;
    }

    @Override
    public String toString() {
        return "ItemReview{" + "itemReviewId=" + itemReviewId + ", reviewText=" + reviewText + ", reply=" + reply + ", userId=" + userId + ", itemId=" + itemId + ", reviewTime=" + reviewTime + ", score=" + score + ", authorName=" + authorName + ", authorSurname=" + authorSurname + '}';
    }
}

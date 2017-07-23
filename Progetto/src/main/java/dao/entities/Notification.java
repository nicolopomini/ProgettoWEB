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
public class Notification {
    private Integer notificationId;
    private Integer userId;
    private String notificationText;
    private Boolean seen;

    public Integer getNotificationId() {
        return notificationId;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getNotificationText() {
        return notificationText;
    }

    public Boolean getSeen() {
        return seen;
    }

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setNotificationText(String notificationText) {
        this.notificationText = notificationText;
    }

    public void setSeen(Boolean seen) {
        this.seen = seen;
    }

    @Override
    public String toString() {
        return "Notification{" + "notificationId=" + notificationId + ", userId=" + userId + ", notificationText=" + notificationText + ", seen=" + seen + '}';
    }
}

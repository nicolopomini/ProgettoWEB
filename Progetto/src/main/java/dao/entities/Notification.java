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
    private Integer author, recipient;
    private String notificationText;
    private String notificationTime;
    private Boolean seen;
    private String type;

    public Integer getNotificationId() {
        return notificationId;
    }

    public Integer getAuthor() {
        return author;
    }

    public String getNotificationText() {
        return notificationText;
    }

    public Boolean getSeen() {
        return seen;
    }

    public String getNotificationTime() {
        return notificationTime;
    }

    public Integer getRecipient() {
        return recipient;
    }

    public String getType() {
        return type;
    }

    public void setNotificationTime(String notificationTime) {
        this.notificationTime = notificationTime;
    }

    public void setRecipient(Integer recipient) {
        this.recipient = recipient;
    }

    public void setType(String type) {
        this.type = type;
    }
    
    

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public void setAuthor(Integer author) {
        this.author = author;
    }

    public void setNotificationText(String notificationText) {
        this.notificationText = notificationText;
    }

    public void setSeen(Boolean seen) {
        this.seen = seen;
    }

    @Override
    public String toString() {
        return "Notification{" + "notificationId=" + notificationId + ", userId=" + author + ", notificationText=" + notificationText + ", seen=" + seen + ", notificationTime=" + notificationTime + ", recipient=" + recipient + ", type=" + type + '}';
    }
}

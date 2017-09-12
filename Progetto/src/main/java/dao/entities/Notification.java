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
    public static final String NEWCOMMENTSHOP = "newcommentshop", REPLYCOMMENTSHOP = "replycommentshop", NEWCOMMENTITEM = "newcommentitem", REPLYCOMMENTITEM = "replycommentitem", REPLYCOMPLAINT = "replycomplaint";
    
    private Integer notificationId;
    private Integer author, recipient;
    private String notificationText;
    private String notificationTime;
    private Boolean seen;
    private String type, link;
    private String authorName, authorSurname;

    public String getAuthorName() {
        return authorName;
    }

    public String getAuthorSurname() {
        return authorSurname;
    }

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

    public String getLink() {
        return link;
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

    public void setLink(String link) {
        this.link = link;
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

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public void setAuthorSurname(String authorSurname) {
        this.authorSurname = authorSurname;
    }

    
    @Override
    public String toString() {
        return "Notification{" + "notificationId=" + notificationId + ", userId=" + author + ", notificationText=" + notificationText + ", seen=" + seen + ", notificationTime=" + notificationTime + ", recipient=" + recipient + ", type=" + type + ",link=" + link + '}';
    }
}

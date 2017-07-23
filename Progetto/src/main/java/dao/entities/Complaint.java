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
public class Complaint {
    private Integer complaintId;
    private Integer purchaseId;
    private String complaintTime;
    private String complaintText;
    private String reply;
    private String status;

    public Integer getComplaintId() {
        return complaintId;
    }

    public Integer getPurchaseId() {
        return purchaseId;
    }

    public String getComplaintTime() {
        return complaintTime;
    }

    public String getComplaintText() {
        return complaintText;
    }

    public String getReply() {
        return reply;
    }

    public String getStatus() {
        return status;
    }

    public void setComplaintId(Integer complaintId) {
        this.complaintId = complaintId;
    }

    public void setPurchaseId(Integer purchaseId) {
        this.purchaseId = purchaseId;
    }

    public void setComplaintTime(String complaintTime) {
        this.complaintTime = complaintTime;
    }

    public void setComplaintText(String complaintText) {
        this.complaintText = complaintText;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Complaint{" + "complaintId=" + complaintId + ", purchaseId=" + purchaseId + ", complaintTime=" + complaintTime + ", complaintText=" + complaintText + ", reply=" + reply + ", status=" + status + '}';
    }
}

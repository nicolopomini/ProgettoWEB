/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.ComplaintDAO;
import dao.entities.Complaint;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.jdbc.JDBCDAO;

/**
 *
 * @author Gabriele
 */

public class JDBCComplaintDAO extends JDBCDAO<Complaint, Integer> implements ComplaintDAO{

    public JDBCComplaintDAO(Connection con) {
        super(con);
    }
    
    @Override
    public Integer getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM Complaint");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count complaints", ex);
        }

        return 0;
    }

    @Override
    public Complaint getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Complaint WHERE complaintId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                Complaint complaint = new Complaint();
                complaint.setComplaintId(rs.getInt("complaintId"));
                complaint.setPurchaseId(rs.getInt("purchaseId"));
                complaint.setComplaintTime(rs.getString("complaintTime"));
                complaint.setComplaintText(rs.getString("complaintText"));
                complaint.setReply(rs.getString("reply"));
                complaint.setStatus(rs.getString("status"));

                return complaint;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the complaint for the passed primary key", ex);
        }
    }

    @Override
    public List<Complaint> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Complaint order by complainttime desc")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Complaint> complaints = new ArrayList<>();
                while(rs.next())
                {
                    Complaint complaint = new Complaint();
                    complaint.setComplaintId(rs.getInt("complaintId"));
                    complaint.setPurchaseId(rs.getInt("purchaseId"));
                    complaint.setComplaintTime(rs.getString("complaintTime"));
                    complaint.setComplaintText(rs.getString("complaintText"));
                    complaint.setReply(rs.getString("reply"));
                    complaint.setStatus(rs.getString("status"));
                    complaints.add(complaint);
                }
                return complaints;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get complaints", ex);
        }
    }

    @Override
    public Complaint update(Complaint complaint) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("UPDATE Complaint SET purchaseId = ?, complaintTime = ?, complaintText = ?, reply = ?, status = ? WHERE complaintId = ?;")) {
            stm.setInt(1, complaint.getPurchaseId());
            stm.setString(2, complaint.getComplaintTime());
            stm.setString(3, complaint.getComplaintText());
            stm.setString(4, complaint.getReply());
            stm.setString(5, complaint.getStatus());
            stm.setInt(6, complaint.getComplaintId());
            stm.executeUpdate();
            return complaint;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the complaint", ex);
        }
    }

    @Override
    public Complaint add(Complaint complaint) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO Complaint (purchaseId, complaintTime, complaintText, reply, status) VALUES (?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, complaint.getPurchaseId());
            stm.setString(2, complaint.getComplaintTime());
            stm.setString(3, complaint.getComplaintText());
            stm.setString(4, complaint.getReply());
            stm.setString(5, complaint.getStatus());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int complaintId = rs.getInt(1);
                complaint.setComplaintId(complaintId);
            }
            return complaint;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the complaint", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Complaint WHERE complaintId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the complaint", ex);
        }
    }

    @Override
    public ArrayList<Complaint> getNewComplaints() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Complaint where status = \"" + Complaint.STATUS_NEW + "\"order by complaintTime")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Complaint> complaints = new ArrayList<>();
                while(rs.next())
                {
                    Complaint complaint = new Complaint();
                    complaint.setComplaintId(rs.getInt("complaintId"));
                    complaint.setPurchaseId(rs.getInt("purchaseId"));
                    complaint.setComplaintTime(rs.getString("complaintTime"));
                    complaint.setComplaintText(rs.getString("complaintText"));
                    complaint.setReply(rs.getString("reply"));
                    complaint.setStatus(rs.getString("status"));
                    complaints.add(complaint);
                }
                return complaints;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get new complaints", ex);
        }
    }

    @Override
    public int getUnread() throws DAOException {
        try {
            PreparedStatement stm = CON.prepareStatement("select count(*) as c from Complaint where status = \"new\";");
            ResultSet rs = stm.executeQuery();
            if(rs.next())
                return rs.getInt("c");
            else
                return 0;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get unread complaints",ex);
        }
    }

    @Override
    public void readComplaint(int complaintId) throws DAOException {
        try {
            PreparedStatement stm = CON.prepareStatement("update Complaint set status = 'seen' where complaintId = ?;");
            stm.setInt(1, complaintId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to read the complaint",ex);
        }
    }

    @Override
    public ArrayList<Complaint> getComplaintByAuthor(int userId) throws DAOException {
        try {
            PreparedStatement stm = CON.prepareStatement("select Complaint.purchaseId as purchaseId, complaintId, complaintTime, complaintText, reply, status from Complaint, Purchase where Complaint.purchaseId = Purchase.purchaseId and Purchase.userId = ?;");
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            ArrayList<Complaint> complaints = new ArrayList<>();
                while(rs.next())
                {
                    Complaint complaint = new Complaint();
                    complaint.setComplaintId(rs.getInt("complaintId"));
                    complaint.setPurchaseId(rs.getInt("purchaseId"));
                    complaint.setComplaintTime(rs.getString("complaintTime"));
                    complaint.setComplaintText(rs.getString("complaintText"));
                    complaint.setReply(rs.getString("reply"));
                    complaint.setStatus(rs.getString("status"));
                    complaints.add(complaint);
                }
                return complaints;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the complaints",ex);
        }
    }
}
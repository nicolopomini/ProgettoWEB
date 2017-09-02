/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.NotificationDAO;
import dao.entities.Notification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.jdbc.JDBCDAO;

/**
 *
 * @author Gabriele
 */

public class JDBCNotificationDAO extends JDBCDAO<Notification, Integer> implements NotificationDAO{

    public JDBCNotificationDAO(Connection con) {
        super(con);
    } 

    @Override
    public Integer getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM Notification");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count notifications", ex);
        }

        return 0;
    }

    @Override
    public Notification getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Notification WHERE notificationId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                Notification notification = new Notification();
                notification.setNotificationId(rs.getInt("notificationId"));
                notification.setAuthor(rs.getInt("author"));
                notification.setNotificationText(rs.getString("notificationText"));
                notification.setSeen(rs.getBoolean("seen"));
                notification.setNotificationTime(rs.getString("notificationTime"));
                notification.setRecipient(rs.getInt("recipient"));
                notification.setType(rs.getString("type"));
                notification.setLink(rs.getString("link"));

                return notification;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the notification for the passed primary key", ex);
        }
    }

    @Override
    public List<Notification> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Notification")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Notification> notifications = new ArrayList<>();
                while(rs.next())
                {
                    Notification notification = new Notification();
                    notification.setNotificationId(rs.getInt("notificationId"));
                    notification.setAuthor(rs.getInt("author"));
                    notification.setNotificationText(rs.getString("notificationText"));
                    notification.setSeen(rs.getBoolean("seen"));
                    notification.setNotificationTime(rs.getString("notificationTime"));
                    notification.setRecipient(rs.getInt("recipient"));
                    notification.setType(rs.getString("type"));
                    notification.setLink(rs.getString("link"));
                    notifications.add(notification);
                }
                return notifications;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get notifications", ex);
        }
    }

    @Override
    public Notification update(Notification notification) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("UPDATE Notification SET author = ?, notificationText = ?, seen = ?, recipient = ?, type = ?, notificationTime = ?, link = ?  WHERE notificationId = ?;")) {
            stm.setInt(1, notification.getAuthor());
            stm.setString(2, notification.getNotificationText());
            stm.setBoolean(3, notification.getSeen());
            stm.setInt(4, notification.getRecipient());
            stm.setString(5, notification.getType());
            stm.setString(6, notification.getNotificationTime());
            stm.setString(7, notification.getLink());
            stm.executeUpdate();
            
            return notification;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the notification", ex);
        }
    }

    @Override
    public Notification add(Notification notification) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO Notification (author, notificationText, seen, recipient, type, notificationTime, link) VALUES (?, ?, ?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, notification.getAuthor());
            stm.setString(2, notification.getNotificationText());
            stm.setBoolean(3, notification.getSeen());
            stm.setInt(4, notification.getRecipient());
            stm.setString(5, notification.getType());
            stm.setString(6, notification.getNotificationTime());
            stm.setString(7, notification.getLink());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int notificationId = rs.getInt(1);
                notification.setNotificationId(notificationId);
            }
            return notification;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the notification", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Notification WHERE notificationId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the notification", ex);
        }
    }

    @Override
    public ArrayList<Notification> getByRecipient(int UserId) throws DAOException {
        try {
            PreparedStatement stm = CON.prepareStatement("select * from notification where recipient = ? order by notificationTime;");
            ResultSet rs = stm.executeQuery();
            ArrayList<Notification> l = new ArrayList<>(); 
            while(rs.next()) {
                Notification n = new Notification();
                n.setAuthor(rs.getInt("author"));
                n.setLink(rs.getString("link"));
                n.setNotificationId(rs.getInt("notificationId"));
                n.setNotificationText(rs.getString("text"));
                n.setNotificationTime(rs.getString("notificationTime"));
                n.setRecipient(rs.getInt("recipient"));
                n.setSeen(rs.getBoolean("seen"));
                n.setType(rs.getString("type"));
                l.add(n);
            }
            return l;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get notifications", ex);
        }
        
    }
    
}

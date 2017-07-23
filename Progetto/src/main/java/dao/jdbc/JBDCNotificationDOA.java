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
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.jdbc.JDBCDAO;

/**
 *
 * @author Gabriele
 */

public class JBDCNotificationDOA extends JDBCDAO<Notification, Integer> implements NotificationDAO{

    public JBDCNotificationDOA(Connection con) {
        super(con);
    } 

    @Override
    public Long getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM Notification");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count notifications", ex);
        }

        return 0L;
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
                notification.setUserId(rs.getInt("userId"));
                notification.setNotificationText(rs.getString("notificationText"));
                notification.setSeen(rs.getBoolean("seen"));

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
                    notification.setUserId(rs.getInt("userId"));
                    notification.setNotificationText(rs.getString("notificationText"));
                    notification.setSeen(rs.getBoolean("seen"));
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
        try (PreparedStatement stm = CON.prepareStatement("UPDATE Notification SET userId = ?, notificationText = ?, seen = ? WHERE notificationId = ?;")) {
            stm.setInt(1, notification.getUserId());
            stm.setString(2, notification.getNotificationText());
            stm.setBoolean(3, notification.getSeen());
            stm.setInt(4, notification.getNotificationId());
            stm.executeUpdate();
            
            return notification;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the notification", ex);
        }
    }

    @Override
    public Notification add(Notification notification) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO Notification (userId, notificationText, seen) VALUES (?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, notification.getUserId());
            stm.setString(2, notification.getNotificationText());
            stm.setBoolean(3, notification.getSeen());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int notificationId = rs.getInt(1);
                notification.setUserId(notificationId);
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
}

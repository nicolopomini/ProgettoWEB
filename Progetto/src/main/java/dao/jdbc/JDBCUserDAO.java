/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.UserDAO;
import dao.entities.User;
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
public class JDBCUserDAO extends JDBCDAO<User, Integer> implements UserDAO{

    public JDBCUserDAO(Connection con) {
        super(con);
    }
    
    @Override
    public Integer getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM User");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count users", ex);
        }

        return 0;
    }

    @Override
    public User getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM User WHERE userId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                User user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setName(rs.getString("name"));
                user.setSurname(rs.getString("surname"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setAddress(rs.getString("address"));
                user.setType(rs.getString("type"));
                user.setVerificationCode(rs.getString("verificationCode"));

                return user;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }

    @Override
    public List<User> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM User")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<User> users = new ArrayList<>();
                while(rs.next())
                {
                    User user = new User();
                    user.setUserId(rs.getInt("userId"));
                    user.setName(rs.getString("name"));
                    user.setSurname(rs.getString("surname"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setAddress(rs.getString("address"));
                    user.setType(rs.getString("type"));
                    user.setVerificationCode(rs.getString("verificationCode"));
                    users.add(user);
                }
                return users;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get users", ex);
        }
    }

    @Override
    public User update(User user) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("UPDATE User SET name = ?, surname = ?, email = ?, password = ?, address = ?, type = ?, verificationCode = ? WHERE userId = ?;")) {
            stm.setString(1, user.getName());
            stm.setString(2, user.getSurname());
            stm.setString(3, user.getEmail());
            stm.setString(4, user.getPassword());
            stm.setString(5, user.getAddress());
            stm.setString(6, user.getType());
            stm.setString(7, user.getVerificationCode());
            stm.setInt(8, user.getUserId());
            stm.executeUpdate();
            
            return user;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the user", ex);
        }
    }

    @Override
    public User add(User user) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO User (name, surname, email, password, address, type, verificationCode) VALUES (?, ?, ?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, user.getName());
            stm.setString(2, user.getSurname());
            stm.setString(3, user.getEmail());
            stm.setString(4, user.getPassword());
            stm.setString(5, user.getAddress());
            stm.setString(6, user.getType());
            stm.setString(7, user.getVerificationCode());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int userId = rs.getInt(1);
                user.setUserId(userId);
            }
            return user;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the user", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM User WHERE userId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the user", ex);
        }
    }

    @Override
    public User getUserByActivationCode(String activationCode) throws DAOException {
         if (activationCode== null) {
            throw new DAOException("activationCode is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM User WHERE verificationCode = ?")) {
            stm.setString(1, activationCode);
            try (ResultSet rs = stm.executeQuery()) {

                User user = new User();
                while(rs.next())
                {
                    user.setUserId(rs.getInt("userId"));
                    user.setName(rs.getString("name"));
                    user.setSurname(rs.getString("surname"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setAddress(rs.getString("address"));
                    user.setType(rs.getString("type"));
                    user.setVerificationCode(rs.getString("verificationCode"));
                }
                return user;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed activationCode", ex);
        }
    }

    @Override
    public User getUserByEmail(String email) throws DAOException {
        if (email== null) {
            throw new DAOException("email is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM User WHERE email = ?")) {
            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {

                User user = new User();
                while(rs.next())
                {
                    user.setUserId(rs.getInt("userId"));
                    user.setName(rs.getString("name"));
                    user.setSurname(rs.getString("surname"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setAddress(rs.getString("address"));
                    user.setType(rs.getString("type"));
                    user.setVerificationCode(rs.getString("verificationCode"));
                }
                return user;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed email", ex);
        }
    }
}
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
    public Long getCount() throws DAOException {
        try (PreparedStatement stmt = CON.prepareStatement("SELECT COUNT(*) FROM User");) {
            ResultSet counter = stmt.executeQuery();
            if (counter.next()) {
                return counter.getLong(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count users", ex);
        }

        return 0L;
    }

    @Override
    public User getByPrimaryKey(Integer primaryKey) throws DAOException {
        return null;
    }

    @Override
    public List<User> getAll() throws DAOException {
        return null;
    }

    @Override
    public User update(User entity) throws DAOException {
        return null;
    }
    
}

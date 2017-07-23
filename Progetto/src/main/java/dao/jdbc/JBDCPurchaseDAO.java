/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.PurchaseDAO;
import dao.entities.Purchase;
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

public class JBDCPurchaseDAO extends JDBCDAO<Purchase, Integer> implements PurchaseDAO{

    public JBDCPurchaseDAO(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        try (PreparedStatement stmt = CON.prepareStatement("SELECT COUNT(*) FROM Purchase");) {
            ResultSet counter = stmt.executeQuery();
            if (counter.next()) {
                return counter.getLong(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count purchases", ex);
        }

        return 0L;
    }

    @Override
    public Purchase getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Purchase WHERE purchaseId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                Purchase purchase = new Purchase();
                purchase.setPurchaseId(rs.getInt("purchaseId"));
                purchase.setPurchaseTime(rs.getString("purchaseTime"));
                purchase.setUserId(rs.getInt("userId"));
                purchase.setItemId(rs.getInt("itemId"));
                purchase.setQuantity(rs.getInt("quantity"));

                return purchase;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the purchase for the passed primary key", ex);
        }
    }

    @Override
    public List<Purchase> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Purchase")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Purchase> purchases = new ArrayList<>();
                while(rs.next())
                {
                    Purchase purchase = new Purchase();
                    purchase.setPurchaseId(rs.getInt("purchaseId"));
                    purchase.setPurchaseTime(rs.getString("purchaseTime"));
                    purchase.setUserId(rs.getInt("userId"));
                    purchase.setItemId(rs.getInt("itemId"));
                    purchase.setQuantity(rs.getInt("quantity"));
                    
                    purchases.add(purchase);
                }
                return purchases;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get purchases", ex);
        }
    }

    @Override
    public Purchase update(Purchase purchase) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("UPDATE Purchase SET purchaseTime = ?, userId = ?, itemId = ?, quantity = ? WHERE purchaseId = ?;")) {
            stm.setString(1, purchase.getPurchaseTime());
            stm.setInt(2, purchase.getUserId());
            stm.setInt(3, purchase.getItemId());
            stm.setInt(4, purchase.getQuantity());
            stm.setInt(5, purchase.getPurchaseId());
            stm.executeUpdate();
            
            return purchase;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the purchase", ex);
        }
    }

    @Override
    public Purchase add(Purchase purchase) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO Purchase (purchaseTime, userId, itemId, quantity) VALUES (?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, purchase.getPurchaseTime());
            stm.setInt(2, purchase.getUserId());
            stm.setInt(3, purchase.getItemId());
            stm.setInt(4, purchase.getQuantity());
            
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int purchaseId = rs.getInt(1);
                purchase.setUserId(purchaseId);
            }
            return purchase;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the purchase", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Purchase WHERE purchaseId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the purchase", ex);
        }
    }
}

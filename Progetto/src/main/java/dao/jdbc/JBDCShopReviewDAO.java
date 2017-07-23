/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.ShopReviewDAO;
import dao.entities.ItemReview;
import dao.entities.ShopReview;
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

public class JBDCShopReviewDAO extends JDBCDAO<ShopReview, Integer> implements ShopReviewDAO{

    public JBDCShopReviewDAO(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        try (PreparedStatement stmt = CON.prepareStatement("SELECT COUNT(*) FROM ShopReview");) {
            ResultSet counter = stmt.executeQuery();
            if (counter.next()) {
                return counter.getLong(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count shopReviews", ex);
        }

        return 0L;
    }

    @Override
    public ShopReview getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ShopReview WHERE shopReviewId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                ShopReview shopReview = new ShopReview();
                shopReview.setShopReviewId(rs.getInt("shopReviewId"));
                shopReview.setReviewText(rs.getString("reviewText"));
                shopReview.setReply(rs.getString("reply"));
                shopReview.setUserId(rs.getInt("userId"));
                shopReview.setShopId(rs.getInt("shopId"));
                shopReview.setReviewTime(rs.getString("reviewTime"));

                return shopReview;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the shopReview for the passed primary key", ex);
        }
    }

    @Override
    public List<ShopReview> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ShopReview")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<ShopReview> shopReviews = new ArrayList<>();
                while(rs.next())
                {
                    ShopReview shopReview = new ShopReview();
                    shopReview.setShopReviewId(rs.getInt("shopReviewId"));
                    shopReview.setReviewText(rs.getString("reviewText"));
                    shopReview.setReply(rs.getString("reply"));
                    shopReview.setUserId(rs.getInt("userId"));
                    shopReview.setShopId(rs.getInt("shopId"));
                    shopReview.setReviewTime(rs.getString("reviewTime"));
                }
                return shopReviews;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get shopReviews", ex);
        }
    }

    @Override
    public ShopReview update(ShopReview shopReview) throws DAOException {
         try (PreparedStatement stm = CON.prepareStatement("UPDATE ShopReview SET reviewText = ?, reply = ?, userId = ?, shopId = ?, reviewTime = ? WHERE shopReviewId = ?;")) {
            stm.setString(1, shopReview.getReviewText());
            stm.setString(2, shopReview.getReply());
            stm.setInt(3, shopReview.getUserId());
            stm.setInt(4, shopReview.getShopId());
            stm.setString(5, shopReview.getReviewTime());
            stm.setInt(6, shopReview.getShopReviewId());
            stm.executeUpdate();
            return shopReview;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the shopReview", ex);
        }
    }

    @Override
    public ShopReview add(ShopReview shopReview) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO ShopReview (reviewText, reply, userId, shopId, reviewTime) VALUES (?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, shopReview.getReviewText());
            stm.setString(2, shopReview.getReply());
            stm.setInt(3, shopReview.getUserId());
            stm.setInt(4, shopReview.getShopId());
            stm.setString(5, shopReview.getReviewTime());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int shopReviewId = rs.getInt(1);
                shopReview.setShopReviewId(shopReviewId);
            }
            return shopReview;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the shopReview", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM ShopReview WHERE shopReviewId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the shopReview", ex);
        }
    }
}

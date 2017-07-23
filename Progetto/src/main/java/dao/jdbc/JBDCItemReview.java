/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.ItemReviewDAO;
import dao.entities.ItemReview;
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

public class JBDCItemReview extends JDBCDAO<ItemReview, Integer> implements ItemReviewDAO{

    public JBDCItemReview(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM ItemReview");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count itemReviews", ex);
        }

        return 0L;
    }

    @Override
    public ItemReview getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ItemReview WHERE itemReviewId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                ItemReview itemReview = new ItemReview();
                itemReview.setItemReviewId(rs.getInt("itemReviewId"));
                itemReview.setReviewText(rs.getString("reviewText"));
                itemReview.setReply(rs.getString("reply"));
                itemReview.setUserId(rs.getInt("userId"));
                itemReview.setItemId(rs.getInt("itemId"));
                itemReview.setReviewTime(rs.getString("reviewTime"));

                return itemReview;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the itemReview for the passed primary key", ex);
        }
    }

    @Override
    public List<ItemReview> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ItemReview")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<ItemReview> itemReviews = new ArrayList<>();
                while(rs.next())
                {
                    ItemReview itemReview = new ItemReview();
                    itemReview.setItemReviewId(rs.getInt("itemReviewId"));
                    itemReview.setReviewText(rs.getString("reviewText"));
                    itemReview.setReply(rs.getString("reply"));
                    itemReview.setUserId(rs.getInt("userId"));
                    itemReview.setItemId(rs.getInt("itemId"));
                    itemReview.setReviewTime(rs.getString("reviewTime"));
                    itemReviews.add(itemReview);
                }
                return itemReviews;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get itemReviews", ex);
        }
    }

    @Override
    public ItemReview update(ItemReview itemReview) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("UPDATE ItemReview SET reviewText = ?, reply = ?, userId = ?, itemId = ?, reviewTime = ? WHERE itemReviewId = ?;")) {
            stm.setString(1, itemReview.getReviewText());
            stm.setString(2, itemReview.getReply());
            stm.setInt(3, itemReview.getUserId());
            stm.setInt(4, itemReview.getItemId());
            stm.setString(5, itemReview.getReviewTime());
            stm.setInt(6, itemReview.getItemReviewId());
            stm.executeUpdate();
            return itemReview;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the itemReview", ex);
        }
    }

    @Override
    public ItemReview add(ItemReview itemReview) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO ItemReview (reviewText, reply, userId, itemId, reviewTime) VALUES (?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, itemReview.getReviewText());
            stm.setString(2, itemReview.getReply());
            stm.setInt(3, itemReview.getUserId());
            stm.setInt(4, itemReview.getItemId());
            stm.setString(5, itemReview.getReviewTime());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int itemReviewId = rs.getInt(1);
                itemReview.setItemReviewId(itemReviewId);
            }
            return itemReview;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the itemReview", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM ItemReview WHERE itemReviewId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the itemReview", ex);
        }
    }

    @Override
    public ArrayList<ItemReview> getByItem(Integer itemId) throws DAOException {
        if (itemId == null) {
            throw new DAOException("itemId is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ItemReview WHERE itemId = ?")) {
            stm.setInt(1, itemId);
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<ItemReview> itemReviews = new ArrayList<>();
                while(rs.next())
                {
                    ItemReview itemReview = new ItemReview();
                    itemReview.setItemReviewId(rs.getInt("itemReviewId"));
                    itemReview.setReviewText(rs.getString("reviewText"));
                    itemReview.setReply(rs.getString("reply"));
                    itemReview.setUserId(rs.getInt("userId"));
                    itemReview.setItemId(rs.getInt("itemId"));
                    itemReview.setReviewTime(rs.getString("reviewTime"));
                    itemReviews.add(itemReview);
                }
                return itemReviews;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get itemReviews for the passed itemId", ex);
        }
    }
}

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

public class JDBCItemReviewDAO extends JDBCDAO<ItemReview, Integer> implements ItemReviewDAO{

    public JDBCItemReviewDAO(Connection con) {
        super(con);
    }

    @Override
    public Integer getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM ItemReview");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count itemReviews", ex);
        }

        return 0;
    }

    @Override
    public ItemReview getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ItemReview, User WHERE itemReviewId = ? AND ItemReview.userId = User.userId")) {
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
                itemReview.setScore(rs.getInt("score"));
                itemReview.setAuthorName(rs.getString("name"));
                itemReview.setAuthorSurname(rs.getString("surname"));

                return itemReview;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the itemReview for the passed primary key", ex);
        }
    }

    @Override
    public List<ItemReview> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ItemReview, User WHERE ItemReview.userId = User.userId")) {
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
                    itemReview.setScore(rs.getInt("score"));
                    itemReview.setAuthorName(rs.getString("name"));
                    itemReview.setAuthorSurname(rs.getString("surname"));
                    
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
        try (PreparedStatement stm = CON.prepareStatement("UPDATE ItemReview SET reviewText = ?, reply = ?, userId = ?, itemId = ?, reviewTime = ?, score = ? WHERE itemReviewId = ?;")) {
            stm.setString(1, itemReview.getReviewText());
            stm.setString(2, itemReview.getReply());
            stm.setInt(3, itemReview.getUserId());
            stm.setInt(4, itemReview.getItemId());
            stm.setString(5, itemReview.getReviewTime());
            stm.setInt(6, itemReview.getScore());
            stm.setInt(7, itemReview.getItemReviewId());
            stm.executeUpdate();
            return itemReview;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the itemReview", ex);
        }
    }

    @Override
    public ItemReview add(ItemReview itemReview) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO ItemReview (reviewText, reply, userId, itemId, reviewTime, score) VALUES (?, ?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, itemReview.getReviewText());
            stm.setString(2, itemReview.getReply());
            stm.setInt(3, itemReview.getUserId());
            stm.setInt(4, itemReview.getItemId());
            stm.setString(5, itemReview.getReviewTime());
            stm.setInt(6, itemReview.getScore());
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
    public ArrayList<ItemReview> getByItemId(Integer itemId) throws DAOException {
        if (itemId == null) {
            throw new DAOException("itemId is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ItemReview, User WHERE itemId = ? AND ItemReview.userId = User.userId")) {
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
                    itemReview.setScore(rs.getInt("score"));
                    itemReview.setAuthorName(rs.getString("name"));
                    itemReview.setAuthorSurname(rs.getString("surname"));
                    
                    itemReviews.add(itemReview);
                }
                return itemReviews;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get itemReviews for the passed itemId", ex);
        }
    }

    @Override
    public Double getAverageScoreByItemId(Integer itemId) throws DAOException {
        if (itemId == null) {
            throw new DAOException("itemId is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT AVG(score) FROM ItemReview WHERE itemId = ?");) {
            stm.setInt(1, itemId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get average score", ex);
        }
        return 0d;
    }
}

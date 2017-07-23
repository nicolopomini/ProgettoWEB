/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.ShopReview;
import java.util.ArrayList;
import persistence.utils.dao.DAO;

/**
 *
 * @author Gabriele
 */

public interface ShopReviewDAO extends DAO<ShopReview, Integer>{
    /**
     * Get all the review related to a shop
     * @param shopId the shop required
     * @return a list with all comments
     */
    //public ArrayList<ShopReview> getReviews(int shopId);
    /**
     * Method to insert a new review to a shop
     * @param shopId related shop
     * @param userId author of the review
     * @param text content of the review
     * @return true if the operation is finished successfully, false otherwise
     */
    //public boolean insertReview(int shopId, int userId, String text);
    /**
     * Method for sellers to reply a review
     * @param reviewId the id of the review to reply
     * @param reply reply content
     * @return true if the operation is finished successfully, false otherwise
     */
    //public boolean replyReview(int reviewId, String reply);
}

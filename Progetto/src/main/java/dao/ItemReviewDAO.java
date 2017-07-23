/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.ItemReview;
import java.util.ArrayList;
import persistence.utils.dao.DAO;

/**
 *
 * @author Gabriele
 */
public interface ItemReviewDAO extends DAO<ItemReview, Integer>{
    /**
     * Get all the review related to an item
     * @param itemId the item required
     * @return a list with all comments
     */
    //public ArrayList<ItemReview> getReviews(int itemId);
    /**
     * Method to insert a new review to an item
     * @param itemId related item
     * @param userId author of the review
     * @param text content of the review
     * @return true if the operation is finished successfully, false otherwise
     */
    //public boolean insertReview(int itemId, int userId, String text);
    /**
     * Method for sellers to reply a review
     * @param reviewId the id of the review to reply
     * @param reply reply content
     * @return true if the operation is finished successfully, false otherwise
     */
    //public boolean replyReview(int reviewId, String reply);
}

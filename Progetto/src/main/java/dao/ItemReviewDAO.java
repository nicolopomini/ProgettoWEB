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
    //public boolean insertReview(int itemId, int userId, String text);

}

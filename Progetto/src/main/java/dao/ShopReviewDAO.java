/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.ShopReview;
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
}

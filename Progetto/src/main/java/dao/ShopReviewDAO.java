/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.ShopReview;
import java.util.ArrayList;
import persistence.utils.dao.DAO;
import persistence.utils.dao.exceptions.DAOException;

/**
 *
 * @author Gabriele
 */

public interface ShopReviewDAO extends DAO<ShopReview, Integer>{
    /**
     * Get all the review related to a shop
     * @param shopId the shop required
     * @return a list with all comments
     * @throws persistence.utils.dao.exceptions.DAOException
     */
    public ArrayList<ShopReview> getByShopId(Integer shopId) throws DAOException;
    
    public Double getAverageScoreByShopId(Integer shopId) throws DAOException;
}

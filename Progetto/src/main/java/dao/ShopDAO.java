/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.Shop;
import persistence.utils.dao.DAO;

/**
 *
 * @author Gabriele
 */

public interface ShopDAO extends DAO<Shop, Integer>{
    /**
     * return the required shop
     * @param shopId id of the shop
     * @return the shop with given shopID
     */
    //public Shop getShop(int shopId);
    /**
     * An user can leave a comment to a shop only if it has buoght an item into that shop
     * @param shopId id of the shop
     * @param userId id of the user that is seeing the shop page
     * @return true if given user can leave a comment in the given shop, false otherwise
     */
    //public boolean canComment(int shopId, int userId);
    
    
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.Shop;
import persistence.utils.dao.DAO;
import persistence.utils.dao.exceptions.DAOException;

/**
 *
 * @author Gabriele
 */

public interface ShopDAO extends DAO<Shop, Integer>{
     /**
     * An user can leave a comment to a shop only if it has bought an item from that shop
     * @param shopId id of the shop
     * @param userId id of the user that is seeing the shop page
     * @return true if given user can leave a comment in the given shop, false otherwise
     * @throws persistence.utils.dao.exceptions.DAOException
     */
    public boolean canComment(Integer shopId, Integer userId) throws DAOException;
}
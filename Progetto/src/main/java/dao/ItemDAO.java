/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.Item;
import dao.entities.Shop;
import java.util.ArrayList;
import persistence.utils.dao.DAO;
import persistence.utils.dao.exceptions.DAOException;

/**
 *
 * @author Gabriele
 */

public interface ItemDAO extends DAO<Item, Integer>{
    /**
     * return a list of shops that sell the same item in a range of 5km. Two items are the same if they have the same name and the same category
     * @param item the original item
     * @return a list of shops that sell the same item
     * @throws persistence.utils.dao.exceptions.DAOException
     */
    public ArrayList<Shop> getItemNearby(Item item) throws DAOException;
    /**
     * An user can comment an item only if it has bought that item
     * @param itemId the related item
     * @param userId the related user
     * @return true if given user can leave a comment to the given item, false otherwise
     * @throws persistence.utils.dao.exceptions.DAOException
     */
    public boolean canComment(Integer itemId, Integer userId) throws DAOException;
    
    public ArrayList<Item> findItems(String name, String category, String shop, Integer minPrice, Integer maxPrice, Integer minAvgScore, String geo) throws DAOException;
    
    public ArrayList<String> autoCompletion(String name, String category, String shop, Integer minPrice, Integer maxPrice, Integer minAvgScore) throws DAOException;
    
    public ArrayList<String> getAllCategories() throws DAOException;
    
    public boolean isOwner(int idemId, int userId) throws DAOException;
}

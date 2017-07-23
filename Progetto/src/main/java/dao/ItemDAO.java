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

/**
 *
 * @author Gabriele
 */

public interface ItemDAO extends DAO<Item, Integer>{
    /**
     * Get a specific item
     * @param itemId the id of the required item
     * @return the required item
     */
    //public Item getItem(int itemId);
    /**
     * return a list of shops that sell the same item in a range of 5km. Two items are the same if they have the same name and the same category
     * @param itemId the original item
     * @return a list of shops that sell the same item
     */
    //public ArrayList<Shop> getItemNearby(int itemId);
    /**
     * An user can comment an item only if it has bought that item
     * @param itemId the related item
     * @param userId the related user
     * @return true if given user can leave a comment to the given item, false otherwise
     */
    //public boolean canComment(int itemId, int userId);
}

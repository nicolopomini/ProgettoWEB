/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.Picture;
import java.util.ArrayList;
import persistence.utils.dao.DAO;

/**
 *
 * @author Gabriele
 */
public interface PictureDAO extends DAO<Picture, Integer>{
    /**
     * Insert a picture related to an item
     * @param itemId the related item
     * @param path the server-side path of the picture
     * @return true if the operation is finished successfully, false otherwise
     */
    //public boolean insertPicture(int itemId, String path);
    /**
     * Get all the paths of all the pictures related to an item
     * @param itemId the related item
     * @return a list with all the server-side paths
     */
    //public ArrayList<String> getPictures(int itemId);
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.Picture;
import java.util.ArrayList;
import persistence.utils.dao.DAO;
import persistence.utils.dao.exceptions.DAOException;

/**
 *
 * @author Gabriele
 */
public interface PictureDAO extends DAO<Picture, Integer>{

    /**
     * Get all the paths of all the pictures related to an item
     * @param itemId the related item
     * @return a list with all the server-side paths
     * @throws persistence.utils.dao.exceptions.DAOException
     */
    public ArrayList<Picture> getByItemId(Integer itemId) throws DAOException;
}

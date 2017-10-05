/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.Purchase;
import java.util.ArrayList;
import persistence.utils.dao.DAO;
import persistence.utils.dao.exceptions.DAOException;

/**
 *
 * @author Gabriele
 */

public interface PurchaseDAO extends DAO<Purchase, Integer>{
    public ArrayList<Purchase> getByUserId(int userId) throws DAOException;
}

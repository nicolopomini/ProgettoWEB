/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.User;
import persistence.utils.dao.DAO;
import persistence.utils.dao.exceptions.DAOException;

/**
 *
 * @author Gabriele
 */
public interface UserDAO extends DAO<User, Integer>{
    public User getUserByActivationCode(String activationCode) throws DAOException;
    public User getUserByEmail(String email) throws DAOException;
    public User getUserByToken(String token) throws DAOException;
}

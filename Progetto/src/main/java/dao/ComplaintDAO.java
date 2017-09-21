/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dao.entities.Complaint;
import java.util.ArrayList;
import persistence.utils.dao.DAO;
import persistence.utils.dao.exceptions.DAOException;

/**
 *
 * @author Gabriele
 */
public interface ComplaintDAO extends DAO<Complaint, Integer>{
    public ArrayList<Complaint> getNewComplaints() throws DAOException;
    public int getUnread() throws DAOException;
    public void readComplaint(int complaintId) throws DAOException;
}

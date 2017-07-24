/*
 * AA 2016-2017
 * Introduction to Web Programming
 * Common - DAO
 * UniTN
 */
package persistence.utils.dao;

import java.util.List;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;

/**
 * The basic DAO interface that all DAOs must implement.
 *
 * @author Stefano Chirico &lt;stefano dot chirico at unitn dot it&gt;
 * @param <ENTITY_CLASS> the class of the entity to handle.
 * @param <PRIMARY_KEY> the class of the primary key of the entity the DAO
 * handle.
 * @since 2017.04.17
 */
public interface DAO<ENTITY_CLASS, PRIMARY_KEY> {

    public ENTITY_CLASS add(ENTITY_CLASS entity) throws DAOException;
    public void removeByPrimaryKey(PRIMARY_KEY primaryKey) throws DAOException;
    
    /**
     * Returns the number of records of {@code ENTITY_CLASS} stored on the
     * persistence system of the application.
     *
     * @return the number of records present into the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.170417
     */
    public Integer getCount() throws DAOException;

    /**
     * Returns the {@code ENTITY_CLASS} instance of the storage system record
     * with the primary key equals to the one passed as parameter.
     *
     * @param primaryKey the primary key used to obtain the entity instance.
     * @return the {@code ENTITY_CLASS} instance of the storage system record
     * with the primary key equals to the one passed as parameter or
     * {@code null} if no entities with that primary key is present into the
     * storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.170417
     */
    public ENTITY_CLASS getByPrimaryKey(PRIMARY_KEY primaryKey) throws DAOException;

    /**
     * Returns the list of all the valid entities of type {@code ENTITY_CLASS}
     * stored by the storage system.
     *
     * @return the list of all the valid entities of type {@code ENTITY_CLASS}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.170417
     */
    public List<ENTITY_CLASS> getAll() throws DAOException;
    
    /**
     * Update the entity passed as parameter and returns it.
     * @param entity the entity used to update the persistence system.
     * @return the updated entity.
     * @throws DAOException if an error occurred during the action.
     * 
     * @author Stefano Chirico
     * @since 1.0.170418
     */
    public ENTITY_CLASS update(ENTITY_CLASS entity) throws DAOException;

    /**
     * If this DAO can interact with it, then returns the DAO of class passed as
     * parameter.
     *
     * @param <DAO_CLASS> the class name of the DAO that can interact with this
     * DAO.
     * @param daoClass the class of the DAO that can interact with this DAO.
     * @return the instance of the DAO or null if no DAO of the type passed as
     * parameter can interact with this DAO.
     * @throws DAOFactoryException if an error occurred.
     *
     * @author Stefano Chirico
     * @since 1.0.170417
     */
    public <DAO_CLASS extends DAO> DAO_CLASS getDAO(Class<DAO_CLASS> daoClass) throws DAOFactoryException;
}
/*
 * AA 2016-2017
 * Introduction to Web Programming
 * Common - DAO
 * UniTN
 */
package persistence.utils.dao.jdbc;

import persistence.utils.dao.DAO;
import java.sql.Connection;
import java.util.HashMap;
import persistence.utils.dao.exceptions.DAOFactoryException;

/**
 * This is the base DAO class all concrete DAO using JDBC technology
 * must extend.
 * @param <ENTITY_CLASS> the class of the entities the dao handle.
 * @param <PRIMARY_KEY_CLASS> the class of the primary key of the entity the
 * dao handle.
 * 
 * @author Stefano Chirico
 * @since 1.0.170417
 */
public abstract class JDBCDAO<ENTITY_CLASS, PRIMARY_KEY_CLASS> implements DAO<ENTITY_CLASS, PRIMARY_KEY_CLASS> {
    /**
     * The JDBC {@link Connection} used to access the persistence system.
     */
    protected final Connection CON;
    /**
     * The list of other DAOs this DAO can interact with.
     */
    protected final HashMap<Class, DAO> FRIEND_DAOS;
    
    /**
     * The base constructor for all the JDBC DAOs.
     * @param con the internal {@code Connection}.
     * 
     * @author Stefano Chirico
     * @since 1.0.170417
     */
    protected JDBCDAO(Connection con) {
        super();
        this.CON = con;
        FRIEND_DAOS = new HashMap<>();
    }
    
    /**
     * If this DAO can interact with it, then returns the DAO of class passed
     * as parameter.
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
    @Override
    public <DAO_CLASS extends DAO> DAO_CLASS getDAO(Class<DAO_CLASS> daoClass) throws DAOFactoryException {
        return (DAO_CLASS) FRIEND_DAOS.get(daoClass);
    }   
}
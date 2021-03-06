/*
 * AA 2016-2017
 * Introduction to Web Programming
 * Lab 09 - JSTL ToDoManager
 * UniTN
 */
package listeners;

import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;
import persistence.utils.dao.factories.jdbc.JDBCDAOFactory;

/**
 * Web application lifecycle listener.
 *
 * @author Stefano Chirico &lt;stefano dot chirico at unitn dot it&gt;
 * @since 2017.04.25
 */
public class WebAppContextListener implements ServletContextListener {

    /**
     * The serlvet container call this method when initializes the application
     * for the first time.
     * @param sce the event fired by the servlet container when initializes
     * the application
     * 
     * @author Stefano Chirico
     * @since 1.0.170425
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String dburl = sce.getServletContext().getInitParameter("dburl");
        String user = sce.getServletContext().getInitParameter("dbusername");
        String password = sce.getServletContext().getInitParameter("dbpassword");

        try {
            JDBCDAOFactory.configure(dburl, user, password);
            DAOFactory daoFactory = JDBCDAOFactory.getInstance();

            sce.getServletContext().setAttribute("daoFactory", daoFactory);

        } catch (DAOFactoryException ex) {

            Logger.getLogger(getClass().getName()).severe(ex.toString());

            throw new RuntimeException(ex);

        }
    }

    /**
     * The servlet container call this method when destroyes the application.
     * @param sce the event generated by the servlet container when destroyes
     * the application.
     * 
     * @author Stefano Chirico
     * @since 1.0.170425
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        DAOFactory daoFactory = (DAOFactory) sce.getServletContext().getAttribute("daoFactory");
        if (daoFactory != null) {
            daoFactory.shutdown();
        }
        daoFactory = null;
    }
}
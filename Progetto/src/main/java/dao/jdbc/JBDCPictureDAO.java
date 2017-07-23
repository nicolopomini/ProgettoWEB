/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.PictureDAO;
import dao.entities.Picture;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.jdbc.JDBCDAO;

/**
 *
 * @author Gabriele
 */

public class JBDCPictureDAO extends JDBCDAO<Picture, Integer> implements PictureDAO{

    public JBDCPictureDAO(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM Picture");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count pictures", ex);
        }

        return 0L;
    }

    @Override
    public Picture getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Picture WHERE pictureId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                Picture picture = new Picture();
                picture.setPictureId(rs.getInt("pictureId"));
                picture.setPath(rs.getString("path"));
                picture.setItemId(rs.getInt("itemId"));

                return picture;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the picture for the passed primary key", ex);
        }
    }

    @Override
    public List<Picture> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Picture")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Picture> pictures = new ArrayList<>();
                while(rs.next())
                {
                    Picture picture = new Picture();
                    picture.setPictureId(rs.getInt("pictureId"));
                    picture.setPath(rs.getString("path"));
                    picture.setItemId(rs.getInt("itemId"));
                    
                    pictures.add(picture);
                }
                return pictures;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get pictures", ex);
        }
    }

    @Override
    public Picture update(Picture picture) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("UPDATE Picture SET path = ?, ItemId = ? WHERE pictureId = ?;")) {
            stm.setString(1, picture.getPath());
            stm.setInt(2, picture.getItemId());
            stm.setInt(3, picture.getPictureId());
            stm.executeUpdate();
            
            return picture;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the picture", ex);
        }
    }

    @Override
    public Picture add(Picture picture) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO Picture (path, itemId) VALUES (?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, picture.getPath());
            stm.setInt(2, picture.getItemId());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int pictureId = rs.getInt(1);
                picture.setPictureId(pictureId);
            }
            return picture;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the picture", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Picture WHERE pictureId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the picture", ex);
        }
    }

    @Override
    public ArrayList<Picture> getByItemId(Integer itemId) throws DAOException {
        if (itemId == null) {
            throw new DAOException("itemId is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Picture WHERE itemId = ?")) {
            stm.setInt(1, itemId);
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Picture> pictures = new ArrayList<>();
                while(rs.next())
                {
                    Picture picture = new Picture();
                    picture.setPictureId(rs.getInt("pictureId"));
                    picture.setPath(rs.getString("path"));
                    picture.setItemId(rs.getInt("itemId"));
                    
                    pictures.add(picture);
                }
                return pictures;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get pictures for the passed itemId", ex);
        }
    }
}

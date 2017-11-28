/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.ShopDAO;
import dao.entities.Shop;
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

public class JDBCShopDAO extends JDBCDAO<Shop, Integer> implements ShopDAO{

    public JDBCShopDAO(Connection con) {
        super(con);
    }

    @Override
    public Integer getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM Shop");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count shops", ex);
        }

        return 0;
    }

    @Override
    public Shop getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Shop WHERE shopId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                Shop shop = new Shop();
                shop.setShopId(rs.getInt("shopId"));
                shop.setUserId(rs.getInt("userId"));
                shop.setName(rs.getString("name"));
                shop.setWebsite(rs.getString("website"));
                shop.setAddress(rs.getString("address"));
                shop.setLat(rs.getDouble("lat"));
                shop.setLon(rs.getDouble("lon"));
                shop.setOpeningHours(rs.getString("openingHours"));
                shop.setImagePath(rs.getString("imagePath"));

                return shop;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the shop for the passed primary key", ex);
        }
    }

    @Override
    public List<Shop> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Shop")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Shop> shops = new ArrayList<>();
                while(rs.next())
                {
                    Shop shop = new Shop();
                    shop.setShopId(rs.getInt("shopId"));
                    shop.setUserId(rs.getInt("userId"));
                    shop.setName(rs.getString("name"));
                    shop.setWebsite(rs.getString("website"));
                    shop.setAddress(rs.getString("address"));
                    shop.setLat(rs.getDouble("lat"));
                    shop.setLon(rs.getDouble("lon"));
                    shop.setOpeningHours(rs.getString("openingHours"));
                    shop.setImagePath(rs.getString("imagePath"));
                    
                    shops.add(shop);
                }
                return shops;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get shops", ex);
        }
    }

    @Override
    public Shop update(Shop shop) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("UPDATE Shop SET userId = ?, name = ?, website = ?, address = ?, lat = ?, lon = ?, openingHours = ?, imagePath = ? WHERE shopId = ?;")) {
            stm.setInt(1, shop.getUserId());
            stm.setString(2, shop.getName());
            stm.setString(3, shop.getWebsite());
            stm.setString(4, shop.getAddress());
            stm.setDouble(5, shop.getLat());
            stm.setDouble(6, shop.getLon());
            stm.setString(7, shop.getOpeningHours());
            stm.setString(8, shop.getImagePath());
            stm.setInt(9, shop.getShopId());
            stm.executeUpdate();
            
            return shop;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the shop", ex);
        }
    }

    @Override
    public Shop add(Shop shop) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO Shop (userId, name, website, address, lat, lon, openingHours, imagePath) VALUES (?, ?, ?, ?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, shop.getUserId());
            stm.setString(2, shop.getName());
            stm.setString(3, shop.getWebsite());
            stm.setString(4, shop.getAddress());
            stm.setDouble(5, shop.getLat());
            stm.setDouble(6, shop.getLon());
            stm.setString(7, shop.getOpeningHours());
            stm.setString(8, shop.getImagePath());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int shopId = rs.getInt(1);
                shop.setShopId(shopId);
            }
            return shop;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the shop", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Shop WHERE shopId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the shop", ex);
        }
    }

    @Override
    public boolean canComment(Integer shopId, Integer userId) throws DAOException {
        if (shopId == null) {
            throw new DAOException("shopId is null");
        }
        if (userId == null) {
            throw new DAOException("userId is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM Shop, Item, Purchase WHERE Shop.shopId = Item.shopId AND Item.itemId = Purchase.itemId AND Shop.shopId = ? AND Purchase.userId = ?;");) {
            stm.setInt(1, shopId);
            stm.setInt(2, userId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getLong(1) > 0;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to check whether the user can comment", ex);
        }
        return false;
    }

    @Override
    public ArrayList<Shop> getShopsByOwner(Integer userId) throws DAOException {
        try {
            PreparedStatement stm = CON.prepareStatement("select * from Shop where userId = ?;");
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            ArrayList<Shop> shops = new ArrayList<>();
                while(rs.next())
                {
                    Shop shop = new Shop();
                    shop.setShopId(rs.getInt("shopId"));
                    shop.setUserId(rs.getInt("userId"));
                    shop.setName(rs.getString("name"));
                    shop.setWebsite(rs.getString("website"));
                    shop.setAddress(rs.getString("address"));
                    shop.setLat(rs.getDouble("lat"));
                    shop.setLon(rs.getDouble("lon"));
                    shop.setOpeningHours(rs.getString("openingHours"));
                    shop.setImagePath(rs.getString("imagePath"));
                    
                    shops.add(shop);
                }
                return shops;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get shops", ex);
        }
    }
    
}

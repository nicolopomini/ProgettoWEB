/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.ItemDAO;
import dao.entities.Item;
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

public class JBDCItemDAO extends JDBCDAO<Item, Integer> implements ItemDAO{

    public JBDCItemDAO(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        try (PreparedStatement stmt = CON.prepareStatement("SELECT COUNT(*) FROM Item");) {
            ResultSet counter = stmt.executeQuery();
            if (counter.next()) {
                return counter.getLong(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count items", ex);
        }

        return 0L;
    }

    @Override
    public Item getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Item WHERE itemId = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                Item item = new Item();
                item.setItemId(rs.getInt("itemId"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setCategory(rs.getString("category"));
                item.setPrice(rs.getDouble("price"));
                item.setShopId(rs.getInt("shopId"));

                return item;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the item for the passed primary key", ex);
        }
    }

    @Override
    public List<Item> getAll() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Item")) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Item> items = new ArrayList<>();
                while(rs.next())
                {
                    Item item = new Item();
                    item.setItemId(rs.getInt("itemId"));
                    item.setName(rs.getString("name"));
                    item.setDescription(rs.getString("description"));
                    item.setCategory(rs.getString("category"));
                    item.setPrice(rs.getDouble("price"));
                    item.setShopId(rs.getInt("shopId"));
                    items.add(item);
                }
                return items;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get items", ex);
        }
    }

    @Override
    public Item update(Item item) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("UPDATE Item SET name = ?, description = ?, category = ?, price = ?, shopId = ? WHERE itemId = ?;")) {
            stm.setString(1, item.getName());
            stm.setString(2, item.getDescription());
            stm.setString(3, item.getCategory());
            stm.setDouble(4, item.getPrice());
            stm.setInt(5, item.getShopId());
            stm.setInt(6, item.getItemId());
            stm.executeUpdate();
            return item;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the item", ex);
        }
    }

    @Override
    public Item add(Item item) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO Item (name, description, category, price, shopId) VALUES (?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, item.getName());
            stm.setString(2, item.getDescription());
            stm.setString(3, item.getCategory());
            stm.setDouble(4, item.getPrice());
            stm.setInt(5, item.getShopId());
            stm.executeUpdate();
            
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next())
            {
                int itemId = rs.getInt(1);
                item.setItemId(itemId);
            }
            return item;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to add the item", ex);
        }
    }

    @Override
    public void removeByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Item WHERE userId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the item", ex);
        }
    }
}

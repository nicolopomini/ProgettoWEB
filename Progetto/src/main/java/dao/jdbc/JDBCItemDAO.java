/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.jdbc;

import dao.ItemDAO;
import dao.entities.Item;
import dao.entities.Shop;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.jdbc.JDBCDAO;
import utils.StringUtils;

/**
 *
 * @author Gabriele
 */

public class JDBCItemDAO extends JDBCDAO<Item, Integer> implements ItemDAO{

    private static final double COOR_TO_KM = 0.009;
    private static final double MAX_DISTANCE = 5;
    
    public JDBCItemDAO(Connection con) {
        super(con);
    }

    @Override
    public Integer getCount() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM Item");) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count items", ex);
        }

        return 0;
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
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Item WHERE itemId = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to remove the item", ex);
        }
    }

    @Override
    public boolean canComment(Integer itemId, Integer userId) throws DAOException {
        if (itemId == null) {
            throw new DAOException("itemId is null");
        }
        if (userId == null) {
            throw new DAOException("userId is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM Item, Purchase WHERE Item.itemId = Purchase.itemId AND Item.itemId = ? AND Purchase.userId = ?;");) {
            stm.setInt(1, itemId);
            stm.setInt(2, userId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getLong(1) > 0;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count purchases", ex);
        }
        return false;
    }

    @Override
    public boolean isOwner(int idemId, int userId) throws DAOException {
        try {
            PreparedStatement stm = CON.prepareStatement("select * from item join shop on (item.shopId = shop.shopId) where shop.userId = ? and item.itemId = ?;");
            stm.setInt(1, userId);
            stm.setInt(2, idemId);
            ResultSet rs = stm.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count purchases", ex);
        }
    }
    

    @Override
    public ArrayList<Shop> getItemNearby(Item item) throws DAOException {
        if (item == null) {
            throw new DAOException("item is null");
        }
        
        String query = "SELECT DISTINCT "
                + "NearbyShop.shopId AS shopId, NearbyShop.userId AS userId, "
                + "NearbyShop.name AS name, NearbyShop.website AS website, "
                + "NearbyShop.address AS address, NearbyShop.lat AS lat, "
                + "NearbyShop.lon AS lon, NearbyShop.openingHours AS openingHours, "
                + "NearbyShop.imagePath AS imagePath "
                + "FROM Item, Shop AS NearbyShop, Shop AS OriginalShop "
                + "WHERE Item.shopId = NearbyShop.shopId AND Item.itemId != ? "
                + "AND Item.name LIKE ? AND Item.category = ? AND OriginalShop.shopId = ? "
                + "AND ABS(NearbyShop.lat - OriginalShop.lat) < ? "
                + "AND ABS(NearbyShop.lon - OriginalShop.lon) < ?;";
                
        try (PreparedStatement stm = CON.prepareStatement(query)) {
            stm.setInt(1, item.getItemId());
            stm.setString(2, item.getName());
            stm.setString(3, item.getCategory());
            stm.setInt(4, item.getShopId());
            stm.setDouble(5, COOR_TO_KM * MAX_DISTANCE);
            stm.setDouble(6, COOR_TO_KM * MAX_DISTANCE);
            
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
    public ArrayList<Item> findItems(String name, String category, String shop, Integer minPrice, Integer maxPrice, Integer minAvgScore, String geo) throws DAOException {
        //check input strings
        if(name != null)
            name = StringUtils.checkInputString(name);
        if(geo != null)
            geo = StringUtils.checkInputString(geo);
        
        String statement = "";
        
        String columns = "Item.itemId, Item.name, Item.description, Item.category, Item.price, Item.shopId";
        
        if(name == null)
        {
            statement = "SELECT " + columns + " FROM Item";
        }
        else
        {
            statement = "SELECT " + columns + " FROM ("
                    + "(SELECT * FROM Item WHERE name LIKE \"%" + name + "%\") UNION "
                    + "(SELECT * FROM Item WHERE description LIKE \"%" + name + "%\") UNION "
                    + "(SELECT " + columns + " FROM Item, Shop WHERE Item.shopId = Shop.shopId AND Shop.name LIKE \"%" + name + "%\")) AS Item";
        }
        
        if(minAvgScore != null)
        {
            statement += ", ItemReview";
        }
        
        ArrayList<String> filters = new ArrayList<>();
        
        if(category != null)
        {
            filters.add("Item.category LIKE \"%" + category + "%\"");
        }
        
        if(shop != null)
        {
            filters.add("Item.shopId IN (SELECT shopId FROM Shop WHERE name LIKE \"%" + shop + "%\")");
        }
        
        if(minPrice != null)
        {
            filters.add("Item.price >= " + minPrice);
        }
        
        if(maxPrice != null)
        {
            filters.add("Item.price <= " + maxPrice);
        }
        
        if(minAvgScore != null)
        {
            filters.add("Item.itemId = ItemReview.itemId");
        }
        
        if(filters.size() > 0)
        {
            statement += " WHERE ";
        }
        statement += String.join(" AND ", filters);
        
        if(minAvgScore != null)
        {
            statement += " GROUP BY " + columns + " HAVING AVG(ItemReview.Score) >= " + minAvgScore;
        }
        
        try (PreparedStatement stm = CON.prepareStatement(statement)) {
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
    public ArrayList<String> autocompletion(String name, String category, String shop, Integer minPrice, Integer maxPrice, Integer minAvgScore) throws DAOException {
        String statement = "";
        
        String columns = "Item.itemId, Item.name, Item.description, Item.category, Item.price, Item.shopId";
        
        if(name == null)
        {
            statement = "SELECT " + columns + " FROM Item";
        }
        else
        {
            statement = "SELECT " + columns + " FROM ("
                    + "(SELECT * FROM Item WHERE name LIKE \"%" + name + "%\") UNION "
                    + "(SELECT * FROM Item WHERE description LIKE \"%" + name + "%\") UNION "
                    + "(SELECT " + columns + " FROM Item, Shop WHERE Item.shopId = Shop.shopId AND Shop.name LIKE \"%" + name + "%\")) AS Item";
        }
        
        if(minAvgScore != null)
        {
            statement += ", ItemReview";
        }
        
        ArrayList<String> filters = new ArrayList<>();
        
        if(category != null)
        {
            filters.add("Item.category LIKE \"%" + category + "%\"");
        }
        
        if(shop != null)
        {
            filters.add("Item.shopId IN (SELECT shopId FROM Shop WHERE name LIKE \"%" + shop + "%\")");
        }
        
        if(minPrice != null)
        {
            filters.add("Item.price >= " + minPrice);
        }
        
        if(maxPrice != null)
        {
            filters.add("Item.price <= " + maxPrice);
        }
        
        if(minAvgScore != null)
        {
            filters.add("Item.itemId = ItemReview.itemId");
        }
        
        if(filters.size() > 0)
        {
            statement += " WHERE ";
        }
        statement += String.join(" AND ", filters);
        
        if(minAvgScore != null)
        {
            statement += " GROUP BY " + columns + " HAVING AVG(ItemReview.Score) >= " + minAvgScore;
        }
        
        statement += " LIMIT 10";
        
        try (PreparedStatement stm = CON.prepareStatement(statement)) {
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<String> items = new ArrayList<>();
                while(rs.next())
                {
                    items.add(rs.getString("name"));
                }
                return items;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get items", ex);
        }
    }
    
    @Override
    public ArrayList<String> getAllCategories() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT column_type AS category FROM information_schema.columns WHERE table_name = 'Item' AND column_name = 'category';")) {
            try (ResultSet rs = stm.executeQuery()) {
                rs.next();
                String result = rs.getString("category");
                result = result.replace("enum(", "");
                result = result.replace(")", "");
                result = result.replace("'", "");
                String[] cat = result.split(",");
                
                ArrayList<String> categories = new ArrayList<>(Arrays.asList(cat));
                return categories;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get categories", ex);
        }
    }
}

package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DeviceCategory;

public class CategoryDAO extends DBContext {  
    
    // ===================== GET LIST with FILTER + SEARCH + PAGINATION =====================
    public List<DeviceCategory> getCategoryWithFilter(String search, int page, int pageSize) {
        List<DeviceCategory> list = new ArrayList<>();

        String query = "SELECT * FROM device_category WHERE name LIKE ? ORDER BY id ASC LIMIT ? OFFSET ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, "%" + (search == null ? "" : search) + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DeviceCategory c = new DeviceCategory();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== COUNT for PAGINATION =====================
    public int countCategory(String search) {
        String query = "SELECT COUNT(*) FROM device_category WHERE name LIKE ? ";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, "%" + (search == null ? "" : search) + "%");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ===================== INSERT CATEGORY =====================
    public boolean addCategory(String name) {
        String query = "INSERT INTO device_category(name) VALUES (?)";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== GET ALL (Bạn đã có) =====================
    public List<DeviceCategory> getAllCategory() {
        List<DeviceCategory> listCategory = new ArrayList<>();
        String query = "SELECT * FROM device_category";

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DeviceCategory category = new DeviceCategory();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                listCategory.add(category);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listCategory;
    }

}

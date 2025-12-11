package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DeviceCategory;

public class CategoryDAO extends DBContext {

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

    public List<DeviceCategory> getAllCategory() {
        List<DeviceCategory> listCategory = new ArrayList<>();
        String query = "SELECT * FROM device_category";

        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

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

    public boolean updateCategory(int id, String name) {
        String sql = "UPDATE Category SET name = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public DeviceCategory getCategoryById(int id) {
        String sql = "SELECT * FROM device_category WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                DeviceCategory dc = new DeviceCategory();
                dc.setId(rs.getInt("id"));     // nằm trong BaseEntity
                dc.setName(rs.getString("name"));

                return dc;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isCategoryInUse(int categoryId) {
        String sql = "SELECT COUNT(*) FROM device WHERE category_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0; // true = đang được sử dụng
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return true; // lỗi thì coi như đang được dùng -> tránh xóa nhầm
    }


    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM device_category WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}

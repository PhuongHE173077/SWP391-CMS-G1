package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Device;
import model.DeviceCategory;

public class DeviceDAO extends DBContext {

    public void insertDevice(Device dev) {

        String query = " INSERT INTO swp391.device (created_at,description, image, name, maintenance_time,isDelete, category_id) \n"
                + " VALUES (now(),?,?,?,?,0,?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, dev.getDescription());
            ps.setString(2, dev.getImage());
            ps.setString(3, dev.getName());
            ps.setString(4, dev.getMaintenanceTime());

            int categoryId = dev.getCategory().getId();
            ps.setInt(5, categoryId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteDevice(String id) {
        String query = "UPDATE swp391.device\n"
                + "SET isDelete = 1\n"
                + "WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Device getDeviceById(int deviceId) {
        String query = "SELECT d.*, c.id AS category_id, c.name AS category_name "
                + "FROM device d "
                + "INNER JOIN device_category c ON d.category_id = c.id "
                + "WHERE d.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Device device = new Device();
                    device.setId(rs.getInt("id"));
                    device.setName(rs.getString("name"));
                    device.setDescription(rs.getString("description"));
                    device.setImage(rs.getString("image"));
                    device.setMaintenanceTime(rs.getString("maintenance_time"));
                    device.setIsDelete(rs.getBoolean("isDelete"));

                    DeviceCategory category = new DeviceCategory();
                    category.setId(rs.getInt("category_id"));
                    category.setName(rs.getString("category_name"));
                    device.setCategory(category);
                    
                    java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
                    if (timestamp != null) {
                        OffsetDateTime odt = timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC);
                        device.setCreatedAt(odt);
                    }
                    return device;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Device editDevice(Device dev, String categoryId) {
        String query = "update swp391.device\n"
                + "set name = ?,\n"
                + "description = ?,\n"
                + "image = ?,\n"
                + "maintenance_time = ?,\n"
                + "category_id = ?\n"
                + "where id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, dev.getName());
            ps.setString(2, dev.getDescription());
            ps.setString(3, dev.getImage());
            ps.setString(4, dev.getMaintenanceTime());
            ps.setString(5, categoryId);
            ps.setInt(6, dev.getId());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return dev;
    }

    public List<Device> getFilteredDevicesWithPaging(int indexPage, int PageSize, int categoryId, String textSearch) {
        List<Device> dev = new ArrayList<>();
        String query = "SELECT d.*, c.name AS category_name FROM swp391.device d "
                + " INNER JOIN swp391.device_category c ON d.category_id = c.id"
                + " WHERE d.isDelete = 0";

        List<Object> params = new ArrayList<>();

        if (categoryId > 0) {
            query += " AND d.category_id = ?";
            params.add(categoryId);
        }

        if (textSearch != null && !textSearch.trim().isEmpty()) {
            query += " AND d.name LIKE ?";
            params.add("%" + textSearch + "%");
        }

        query += " ORDER BY d.id LIMIT ? OFFSET ?";

        params.add(PageSize);
        params.add((indexPage - 1) * PageSize);

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Device device = new Device();

                    device.setId(rs.getInt("id"));
                    device.setName(rs.getString("name"));
                    device.setDescription(rs.getString("description"));
                    device.setImage(rs.getString("image"));
                    device.setMaintenanceTime(rs.getString("maintenance_time"));
                    device.setIsDelete(rs.getBoolean("isDelete"));

                    DeviceCategory dc = new DeviceCategory();
                    String categoryName = rs.getString("category_name");
                    int categoryID = rs.getInt("category_id");
                    dc.setName(categoryName);
                    dc.setId(categoryID);
                    device.setCategory(dc);

                    java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
                    if (timestamp != null) {
                        OffsetDateTime odt = timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC);
                        device.setCreatedAt(odt);
                    }
                    dev.add(device);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dev;
    }

    public int getTotalFilteredDevice(int categoryId, String textSearch) {
        String query = "SELECT count(*) FROM swp391.device d WHERE d.isDelete = 0";
        List<Object> params = new ArrayList<>();

        if (categoryId > 0) {
            query += " AND d.category_id = ?";
            params.add(categoryId);
        }

        if (textSearch != null && !textSearch.trim().isEmpty()) {
            query += " AND d.name LIKE ?";
            params.add("%" + textSearch + "%");
        }

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

}

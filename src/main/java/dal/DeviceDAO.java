package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Device;
import model.DeviceCategory;

public class DeviceDAO extends DBContext {

    public List<Device> getAllDevice() {
        List<Device> dev = new ArrayList<>();
        String query = "SELECT * FROM device";
        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Device device = new Device();

                device.setId(rs.getInt("id"));
                device.setName(rs.getString("name"));
                device.setDescription(rs.getString("description"));
                device.setImage(rs.getString("image"));
                device.setMaintenanceTime(rs.getString("maintenance_time"));
                device.setIsDelete(rs.getBoolean("isDelete"));
                java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    OffsetDateTime odt = timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC);
                    device.setCreatedAt(odt);
                } else {
                    device.setCreatedAt(null);
                }
                dev.add(device);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dev;
    }

    public int getTotalAccount() {
        String query = "SELECT count(*) FROM swp391.device";

        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Device> pagingDevice(int indexPage, int PageSize) {
        List<Device> dev = new ArrayList<>();
        String query = "SELECT d.*,  c.name AS category_name \n"
                + "FROM swp391.device d INNER JOIN swp391.device_category c \n"
                + "ON d.category_id = c.id \n"
                + "ORDER BY d.id LIMIT ? OFFSET ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, PageSize);
            ps.setInt(2, (indexPage - 1) * PageSize);
            ResultSet rs = ps.executeQuery();
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
                dc.setName(categoryName);

                device.setCategory(dc);

                java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    OffsetDateTime odt = timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC);
                    device.setCreatedAt(odt);
                } else {
                    device.setCreatedAt(null);
                }
                dev.add(device);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dev;
    }

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
        String query = "delete from swp391.device\n"
                + "where id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, id);
            ps.executeUpdate();          
        } catch (Exception e) {
            e.printStackTrace();
        }   
    }
    
    public List<DeviceCategory> getAllDeviceCategory() {
        String query = "SELECT * FROM swp391.device_category";
        List<DeviceCategory> dc = new ArrayList<>();
     
        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DeviceCategory devc = new DeviceCategory();
                devc.setId(rs.getInt("id"));
                devc.setName(rs.getString("name"));
                 java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    OffsetDateTime odt = timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC);
                    devc.setCreatedAt(odt);
                } else {
                    devc.setCreatedAt(null);
                }
              
                dc.add(devc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dc;
    }

    
     // Lấy thông tin device theo ID
     
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

                    // Set category
                    DeviceCategory category = new DeviceCategory();
                    category.setId(rs.getInt("category_id"));
                    category.setName(rs.getString("category_name"));
                    device.setCategory(category);

                    // Set created_at
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

}

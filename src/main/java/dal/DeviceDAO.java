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

    public List<Device> pagingDevice(int indexPage) {
        List<Device> dev = new ArrayList<>();
        String query = "SELECT d.*,  c.name AS category_name \n"
                + "FROM swp391.device d INNER JOIN swp391.device_category c \n"
                + "ON d.category_id = c.id \n"
                + "ORDER BY d.id LIMIT 3 OFFSET ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, (indexPage - 1) * 3);
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

}

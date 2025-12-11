package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Device;
import model.SubDevice;

public class SubDeviceDAO extends DBContext {

    
     // Lấy danh sách các SubDevice còn lại (isDelete = false) của một device
    
    public List<SubDevice> getRemainingSubDevicesByDeviceId(int deviceId) {
        List<SubDevice> subDevices = new ArrayList<>();
        String query = "SELECT sd.*, d.name AS device_name "
                + "FROM sub_device sd "
                + "INNER JOIN device d ON sd.device_id = d.id "
                + "WHERE sd.device_id = ? AND sd.isDelete = 0 "
                + "ORDER BY sd.id";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SubDevice subDevice = new SubDevice();
                    subDevice.setId(rs.getInt("id"));
                    subDevice.setSeriId(rs.getString("seri_id"));
                    subDevice.setIsDelete(rs.getBoolean("isDelete"));

                    // Set device info
                    Device device = new Device();
                    device.setId(rs.getInt("device_id"));
                    device.setName(rs.getString("device_name"));
                    subDevice.setDevice(device);

                    // Set created_at
                    java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
                    if (timestamp != null) {
                        OffsetDateTime odt = timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC);
                        subDevice.setCreatedAt(odt);
                    }

                    subDevices.add(subDevice);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return subDevices;
    }

    
     //Đếm số lượng SubDevice còn lại của một device
   
    public int countRemainingSubDevicesByDeviceId(int deviceId) {
        String query = "SELECT COUNT(*) FROM sub_device WHERE device_id = ? AND isDelete = 0";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, deviceId);
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

    
     // Thêm một SubDevice mới vào database
     
    public boolean insertSubDevice(SubDevice subDevice) {
        String query = "INSERT INTO sub_device (seri_id, device_id, isDelete, created_at) "
                + "VALUES (?, ?, ?, NOW())";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, subDevice.getSeriId());
            ps.setInt(2, subDevice.getDevice().getId());
            ps.setBoolean(3, subDevice.isIsDelete());
            
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    
      //Thêm nhiều SubDevice cùng lúc (batch insert)
     
    public int insertBatchSubDevices(List<SubDevice> subDevices) {
        String query = "INSERT INTO sub_device (seri_id, device_id, isDelete, created_at) "
                + "VALUES (?, ?, ?, NOW())";
        int count = 0;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            for (SubDevice subDevice : subDevices) {
                ps.setString(1, subDevice.getSeriId());
                ps.setInt(2, subDevice.getDevice().getId());
                ps.setBoolean(3, subDevice.isIsDelete());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            for (int result : results) {
                if (result > 0) {
                    count++;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}


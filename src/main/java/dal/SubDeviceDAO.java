/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Device;
import model.SubDevice;

/**
 *
 * @author admin
 */
public class SubDeviceDAO extends DBContext {

    public List<SubDevice> searchSubDevices(String keyword) {
        List<SubDevice> subDevices = new ArrayList<>();
        String query = "SELECT sd.id as sd_id, sd.seri_id, sd.device_id, sd.isDelete as sd_isDelete, sd.created_at as sd_created_at, "
                +
                "d.id as d_id, d.name, d.image, d.description, d.category_id, d.maintenance_time, d.isDelete as d_isDelete, d.created_at as d_created_at "
                +
                "FROM sub_device sd " +
                "JOIN device d ON sd.device_id = d.id " +
                "WHERE sd.seri_id LIKE ? AND sd.isDelete = 0";
        String searchPattern = "%" + keyword + "%";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    
                    Device device = new Device();
                    device.setId(rs.getInt("d_id"));
                    device.setName(rs.getString("name"));
                    device.setImage(rs.getString("image"));
                    device.setDescription(rs.getString("description"));
                    device.setMaintenanceTime(rs.getString("maintenance_time"));
                    device.setIsDelete(rs.getBoolean("d_isDelete"));
                    if (rs.getObject("d_created_at") != null) {
                        device.setCreatedAt(rs.getObject("d_created_at", OffsetDateTime.class));
                    }

                    
                    SubDevice sdv = new SubDevice();
                    sdv.setId(rs.getInt("sd_id"));
                    sdv.setSeriId(rs.getString("seri_id"));
                    sdv.setIsDelete(rs.getBoolean("sd_isDelete"));
                    if (rs.getObject("sd_created_at") != null) {
                        sdv.setCreatedAt(rs.getObject("sd_created_at", OffsetDateTime.class));
                    }
                    sdv.setDevice(device);

                    subDevices.add(sdv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return subDevices;
    }
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

    
    // Tìm kiếm SubDevice theo số seri trong một device cụ thể
    public List<SubDevice> searchRemainingSubDevicesBySeriId(int deviceId, String seriKeyword) {
        List<SubDevice> subDevices = new ArrayList<>();
        String query = "SELECT sd.*, d.name AS device_name "
                + "FROM sub_device sd "
                + "INNER JOIN device d ON sd.device_id = d.id "
                + "WHERE sd.device_id = ? AND sd.isDelete = 0 AND sd.seri_id LIKE ? "
                + "ORDER BY sd.id";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, deviceId);
            ps.setString(2, "%" + seriKeyword + "%");
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
    
    // Lấy danh sách SubDevice với phân trang (có hỗ trợ search)
    public List<SubDevice> getRemainingSubDevicesByDeviceIdWithPaging(int deviceId, String seriKeyword, int pageIndex, int pageSize) {
        List<SubDevice> subDevices = new ArrayList<>();
        int offset = (pageIndex - 1) * pageSize;
        
        String query = "SELECT sd.*, d.name AS device_name "
                + "FROM sub_device sd "
                + "INNER JOIN device d ON sd.device_id = d.id "
                + "WHERE sd.device_id = ? AND sd.isDelete = 0 ";
        
        if (seriKeyword != null && !seriKeyword.trim().isEmpty()) {
            query += "AND sd.seri_id LIKE ? ";
        }
        
        query += "ORDER BY sd.id LIMIT ? OFFSET ?";
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, deviceId);
            
            if (seriKeyword != null && !seriKeyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + seriKeyword + "%");
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, offset);
            
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
    
    // Đếm số lượng SubDevice còn lại (có hỗ trợ search)
    public int countRemainingSubDevicesByDeviceId(int deviceId, String seriKeyword) {
        String query = "SELECT COUNT(*) FROM sub_device WHERE device_id = ? AND isDelete = 0";
        
        if (seriKeyword != null && !seriKeyword.trim().isEmpty()) {
            query += " AND seri_id LIKE ?";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, deviceId);
            
            if (seriKeyword != null && !seriKeyword.trim().isEmpty()) {
                ps.setString(2, "%" + seriKeyword + "%");
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

    
    // Kiểm tra seri_id đã tồn tại trong hệ thống chưa
    public boolean checkSeriIdExists(String seriId) {
        String query = "SELECT COUNT(*) FROM sub_device WHERE seri_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, seriId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
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
}
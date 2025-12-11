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
}

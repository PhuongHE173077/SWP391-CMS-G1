/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import model.*;

/**
 *
 * @author ADMIN
 */
public class ContractDAO extends DBContext {
    
    public List<Contract> searchContracts(String keyword, String status, int pageIndex, int pageSize, String sortBy, String sortOrder) {
        List<Contract> lst = new ArrayList<>();
        int offset = (pageIndex - 1) * pageSize;
        
    
    
        return null;
        
    
    
    }
    
    public int addContract(int userId, int createById, String content) {
        String sql = "INSERT INTO contract (user_id, createBy, content, isDelete, created_at) VALUES (?, ?, ?, 0, NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, createById);
            ps.setString(3, content);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addContractItem(int contractId, int subDeviceId, int maintenanceMonths) {
        String sql = "INSERT INTO contract_item (contract_id, sub_devicel_id, startAt, endDate, created_at) VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? MONTH), NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.setInt(2, subDeviceId);
            ps.setInt(3, maintenanceMonths);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public SubDevice getSubDeviceById(int subDeviceId) {
        String sql = "SELECT sd.id, sd.seri_id, sd.device_id, sd.isDelete, "
                + "d.id as d_id, d.name, d.maintenance_time "
                + "FROM sub_device sd "
                + "JOIN device d ON sd.device_id = d.id "
                + "WHERE sd.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, subDeviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Device device = new Device();
                    device.setId(rs.getInt("d_id"));
                    device.setName(rs.getString("name"));
                    device.setMaintenanceTime(rs.getString("maintenance_time"));

                    SubDevice sd = new SubDevice();
                    sd.setId(rs.getInt("id"));
                    sd.setSeriId(rs.getString("seri_id"));
                    sd.setDevice(device);
                    return sd;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateSubDeviceIsDelete(int subDeviceId, boolean isDelete) {
        String sql = "UPDATE sub_device SET isDelete = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isDelete);
            ps.setInt(2, subDeviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    
}

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

    public List<Contract> searchContracts(String keyword, String status, int pageIndex, int pageSize, String sortBy,
            String sortOrder) {
        List<Contract> lst = new ArrayList<>();
        int offset = (pageIndex - 1) * pageSize;

        return null;

    }

    public List<Contract> getDeletedContracts(String keyword, int pageIndex, int pageSize, String sortBy,
            String sortOrder) {
        List<Contract> lst = new ArrayList<>();
        int offset = (pageIndex - 1) * pageSize;

        String sql = "SELECT c.id, c.content, c.url_contract, c.isDelete, c.created_at, "
                + "u.id as user_id, u.displayname as user_name, u.email as user_email, "
                + "cb.id as createdBy_id, cb.displayname as createdBy_name "
                + "FROM contract c "
                + "LEFT JOIN _user u ON c.user_id = u.id "
                + "LEFT JOIN _user cb ON c.createBy = cb.id "
                + "WHERE c.isDelete = 1 ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND (c.id LIKE ? OR c.content LIKE ? OR u.displayname LIKE ? OR cb.displayname LIKE ?) ";
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql += "ORDER BY " + sortBy + " " + (sortOrder != null ? sortOrder : "ASC") + " ";
        } else {
            sql += "ORDER BY c.id DESC ";
        }

        sql += "LIMIT ? OFFSET ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Contract contract = new Contract();
                    contract.setId(rs.getInt("id"));
                    contract.setContent(rs.getString("content"));
                    contract.setUrlContract(rs.getString("url_contract"));
                    contract.setIsDelete(rs.getBoolean("isDelete"));

                    Users user = new Users();
                    user.setId(rs.getInt("user_id"));
                    user.setDisplayname(rs.getString("user_name"));
                    user.setEmail(rs.getString("user_email"));
                    contract.setUser(user);

                    Users createdBy = new Users();
                    createdBy.setId(rs.getInt("createdBy_id"));
                    createdBy.setDisplayname(rs.getString("createdBy_name"));
                    contract.setCreateBy(createdBy);

                    lst.add(contract);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lst;
    }

    public int countDeletedContracts(String keyword) {
        String sql = "SELECT COUNT(*) FROM contract c "
                + "LEFT JOIN _user u ON c.user_id = u.id "
                + "LEFT JOIN _user cb ON c.createBy = cb.id "
                + "WHERE c.isDelete = 1 ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND (c.id LIKE ? OR c.content LIKE ? OR u.displayname LIKE ? OR cb.displayname LIKE ?) ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
                ps.setString(3, searchPattern);
                ps.setString(4, searchPattern);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean restoreContract(int contractId) {
        String sql = "UPDATE contract SET isDelete = 0 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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

    public boolean updateContractUrl(int contractId, String urlContract) {
        String sql = "UPDATE contract SET url_contract = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, urlContract);
            ps.setInt(2, contractId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String[] getUserInfoById(int userId) {
        String sql = "SELECT displayname, email, phone, address FROM _user WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[] {
                            rs.getString("displayname"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("address")
                    };
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}

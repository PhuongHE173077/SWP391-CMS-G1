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


public class ContractDAO extends DBContext {

    public List<Contract> searchContracts(String keyword, int createById, String status, int pageIndex, int pageSize, String sortBy, String sortOrder) {
        List<Contract> lst = new ArrayList<>();
        int offset = (pageIndex - 1) * pageSize;

        String sql = "select c.*, u1.displayName as customer_name, u2.displayName as saleStaff_name "
                + "from swp391.contract c "
                + "left join _user u1 on c.user_id = u1.id "
                + "left join _user u2 on c.createBy = u2.id WHERE 1=1 ";

        // --- FILTER ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (c.content LIKE ? OR u1.displayname LIKE ?) ";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND c.isDelete = ? ";
        }
        if (createById > 0) {
            sql += " AND c.createBy = ? ";
        }

        // --- SORT ---
        //default khi hiện list là order by user Id
        String listSort = " ORDER BY c.id DESC";
        if (sortBy != null && !sortBy.isEmpty()) {
            String orderCondition = (sortOrder != null && sortOrder.equalsIgnoreCase("ASC")) ? "ASC" : "DESC";
            switch (sortBy) {
                case "customer":
                    listSort = " ORDER BY u1.displayname " + orderCondition;
                    break;
                case "content":
                    listSort = " ORDER BY c.content " + orderCondition;
                    break;
                case "id":
                    listSort = " ORDER BY c.id " + orderCondition;
                    break;
            }
        }
        sql += listSort;
        sql += " LIMIT ? OFFSET ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (status != null && !status.isEmpty()) {
                // status = "1" -> isDelete = 1 (Active), 0 là inactive
                ps.setBoolean(index++, status.equals("1"));
            }
            if (createById > 0) {
                ps.setInt(index++, createById);
            }
            ps.setInt(index++, pageSize);
            ps.setInt(index++, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract c = new Contract();
                c.setId(rs.getInt("id"));
                c.setContent(rs.getString("content"));
                c.setUrlContract(rs.getString("url_contract"));
                c.setIsDelete(rs.getBoolean("isDelete"));
                // Map Customer Name
                Users customer = new Users();
                customer.setId(rs.getInt("user_id"));
                customer.setDisplayname(rs.getString("customer_name"));
                c.setUser(customer);
                // Map Creator Name
                Users saleStaff = new Users();
                saleStaff.setId(rs.getInt("createBy"));
                saleStaff.setDisplayname(rs.getString("saleStaff_name"));
                c.setCreateBy(saleStaff);
                lst.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lst;
    }

  // Hàm đếm tổng số bản ghi (Để chia trang)
    public int countContracts(String keyword, String status, int createById) {
        String sql = "SELECT COUNT(*) FROM contract c "
                + "LEFT JOIN _user u1 ON c.user_id = u1.id "
                + "WHERE 1=1 ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (c.content LIKE ? OR u1.displayname LIKE ?) ";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND c.isDelete = ? ";
        }
        if (createById > 0) {
            sql += " AND c.createBy = ? ";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(index++, status.equals("1"));
            }
            if (createById > 0) {
                    ps.setInt(index++, createById);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void changeContractStatus(int id, int status) {
        String sql = "UPDATE contract SET isDelete = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, id); //1 Active, 0: Inactive
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        ContractDAO dao = new ContractDAO();
//        List<Contract> lst = dao.searchContracts("","", "", 1, 3, "", "");
//        for (Contract ls : lst) {
//            System.out.println(ls);
//        }

       
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

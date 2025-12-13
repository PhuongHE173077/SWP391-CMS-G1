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
    // HÀM LẤY LIST CONTRACTS CỦA STAFF

    public List<Contract> getAllActiveContracts(String keyword, int createById, int pageIndex, int pageSize, String sortBy,
            String sortOrder) {
        List<Contract> lst = new ArrayList<>();
        int offset = (pageIndex - 1) * pageSize;

        String sql = "select c.*, u1.displayName as customer_name, u2.displayName as saleStaff_name "
                + "from swp391.contract c "
                + "left join _user u1 on c.user_id = u1.id "
                + "left join _user u2 on c.createBy = u2.id where c.isDelete= 0 ";
        // THAM SỐ FILTER TRUYỀN VÀO
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u1.displayName like ? or u2.displayName like ?)";
        }
        if (createById > 0) {
            sql += " AND c.createBy = ?";
        }
        // SORT
        // default khi hiện list là order by user Id
        String listSort = " ORDER BY c.id ASC";
        String orderCondition = "";
        // SORT
        // default khi hiện list là order by user Id
        if (sortBy != null && !sortBy.isEmpty()) {
            if ((sortOrder != null && sortOrder.equalsIgnoreCase("ASC"))) {
                orderCondition = "ASC";
            } else {
                orderCondition = "DESC";
            }
        }

        switch (sortBy) {
            case "customer":
                listSort = " ORDER BY u1.displayname " + orderCondition;
                break;
            case "id":
                listSort = " ORDER BY c.id " + orderCondition;
                break;
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

    // HÀM ĐẾM TỔNG SỐ CONTRACTS => ĐỂ PHÂN TRANG
    public int countAllContracts(String keyword, int createById) {

        String sql = "SELECT COUNT(*) FROM contract c "
                + "LEFT JOIN _user u1 ON c.user_id = u1.id "
                + "LEFT JOIN _user u2 on c.createBy = u2.id "
                + "where c.isDelete= 0 ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u1.displayname LIKE ? OR u2.displayname LIKE ?) ";
        }
        if (createById > 0) {
            sql += " AND c.createBy = ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
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

    public static void main(String[] args) {
        ContractDAO dao = new ContractDAO();
        int total = dao.countAllContracts("", 7);
        System.out.println(total);
    }

    public void changeContractStatus(int id, int status) {
        String sql = "UPDATE contract SET isDelete = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, id); // 1 Active, 0: Inactive
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //
    // Hàm lấy chi tiết 1 hợp đồng theo ID
    public Contract getContractById(int id) {
        String sql = "SELECT c.*, "
                + "u1.displayname AS customer_name, "
                + "u2.displayname AS saleStaff_name "
                + "FROM contract c "
                + "LEFT JOIN _user u1 ON c.user_id = u1.id " // Join lấy khách hàng
                + "LEFT JOIN _user u2 ON c.createBy = u2.id " // Join lấy nhân viên sale
                + "WHERE c.id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Contract c = new Contract();
                c.setId(rs.getInt("id"));
                c.setContent(rs.getString("content"));
                c.setUrlContract(rs.getString("url_contract"));
                c.setIsDelete(rs.getBoolean("isDelete"));

                // --- MAP THÔNG TIN KHÁCH HÀNG (Customer) ---
                Users customer = new Users();
                customer.setId(rs.getInt("user_id"));
                // Lấy tên từ cột giả (alias) customer_name
                customer.setDisplayname(rs.getString("customer_name"));
                c.setUser(customer);

                // --- MAP THÔNG TIN SALE STAFF (CreateBy) ---
                Users saleStaff = new Users();
                saleStaff.setId(rs.getInt("createBy"));
                // Lấy tên từ cột giả (alias) saleStaff_name
                saleStaff.setDisplayname(rs.getString("saleStaff_name"));
                c.setCreateBy(saleStaff);

                return c;
            }
        } catch (SQLException e) {
            System.out.println("Error getContractById: " + e.getMessage());
            e.printStackTrace();
        }
        return null; // Không tìm thấy hoặc lỗi
    }

    public List<ContractItem> getItemsByContractId(int contractId, String keyword, String startDate, String endDate,
            int pageIndex, int pageSize) {

        List<ContractItem> list = new ArrayList<>();
        int offset = (pageIndex - 1) * pageSize;

        // SQL Join 3 bảng: contract_item -> sub_device -> device (để lấy tên máy)
        String sql = "SELECT ci.*, sd.seri_id, d.name as device_name, d.id as device_real_id "
                + "FROM contract_item ci "
                + "INNER JOIN sub_device sd ON ci.sub_devicel_id = sd.id " // Chú ý: sub_devicel_id
                + "INNER JOIN device d ON sd.device_id = d.id "
                + "WHERE ci.contract_id = ? ";

        // --- FILTER ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (d.name LIKE ? OR sd.seri_id LIKE ?) ";
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql += " AND ci.startAt >= ? ";
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql += " AND ci.endDate <= ? ";
        }

        sql += " ORDER BY ci.id DESC LIMIT ? OFFSET ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            ps.setInt(index++, contractId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(index++, startDate ); 
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(index++, endDate);
            }

            ps.setInt(index++, pageSize);
            ps.setInt(index++, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ContractItem item = new ContractItem();
                item.setId(rs.getInt("id"));
                item.setStartAt(rs.getTimestamp("startAt"));
                item.setEndDate(rs.getTimestamp("endDate"));

                // Map SubDevice & Device Info
                SubDevice sd = new SubDevice();
                sd.setId(rs.getInt("sub_devicel_id"));
                sd.setSeriId(rs.getString("seri_id"));

                // Giả sử SubDevice có thuộc tính Device
                Device d = new Device();
                d.setId(rs.getInt("device_real_id"));
                d.setName(rs.getString("device_name"));
                sd.setDevice(d); // Bạn cần đảm bảo Model SubDevice có hàm setDevice
                item.setSubDevice(sd);
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm đếm tổng số Item (Để phân trang)
    public int countItems(int contractId, String keyword, String startDate, String endDate) {
        String sql = "SELECT COUNT(*) FROM contract_item ci "
                + "INNER JOIN sub_device sd ON ci.sub_devicel_id = sd.id "
                + "INNER JOIN device d ON sd.device_id = d.id "
                + "WHERE ci.contract_id = ? ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (d.name LIKE ? OR sd.seri_id LIKE ?) ";
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql += " AND ci.startAt >= ? ";
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql += " AND ci.endDate <= ? ";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            ps.setInt(index++, contractId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(index++, startDate + " 00:00:00");
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(index++, endDate + " 23:59:59");
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

    // Xóa cứng contract (xóa contract và contract_item khỏi database)
    public boolean hardDeleteContract(int contractId) {
        try {
            // Bắt đầu transaction
            connection.setAutoCommit(false);

            // 1. Xóa contract_item trước
            String deleteItemsSql = "DELETE FROM contract_item WHERE contract_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(deleteItemsSql)) {
                ps.setInt(1, contractId);
                ps.executeUpdate();
            }

            // 2. Xóa contract
            String deleteContractSql = "DELETE FROM contract WHERE id = ?";
            try (PreparedStatement ps = connection.prepareStatement(deleteContractSql)) {
                ps.setInt(1, contractId);
                int affected = ps.executeUpdate();

                if (affected > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public int restoreMultipleContracts(List<Integer> contractIds) {
        if (contractIds == null || contractIds.isEmpty()) {
            return 0;
        }

        // Tạo placeholders cho IN clause
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < contractIds.size(); i++) {
            if (i > 0) {
                placeholders.append(",");
            }
            placeholders.append("?");
        }

        String sql = "UPDATE contract SET isDelete = 0 WHERE id IN (" + placeholders.toString() + ")";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < contractIds.size(); i++) {
                ps.setInt(i + 1, contractIds.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
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
                    return new String[]{
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

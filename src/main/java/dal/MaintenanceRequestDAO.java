package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Contract;
import model.ContractItem;
import model.Device;
import model.MaintanceRequest;
import model.ReplyMaintanceRequest;
import model.SubDevice;
import model.Users;
import utils.MaintenanceStatus;

public class MaintenanceRequestDAO extends DBContext {

    // Lấy tất cả contract items (sub-device có seri) đã được thêm vào hợp đồng của
    // user
    public List<ContractItem> getContractItemsByUserId(int userId) {
        List<ContractItem> list = new ArrayList<>();
        String sql = "SELECT ci.id as ci_id, ci.startAt, ci.endDate, ci.created_at as ci_created_at, "
                + "sd.seri_id, sd.id as sub_device_id, "
                + "d.name as device_name, d.id as device_id, d.image as device_image, "
                + "d.maintenance_time as maintenance_time, c.id as contract_id, c.user_id "
                + "FROM contract_item ci "
                + "INNER JOIN contract c ON ci.contract_id = c.id "
                + "INNER JOIN sub_device sd ON ci.sub_devicel_id = sd.id "
                + "INNER JOIN device d ON sd.device_id = d.id "
                + "WHERE c.user_id = ? " // Chỉ lấy contracts của user này
                + "AND c.isDelete = 0 " // Contract chưa bị xóa
                + "AND ci.sub_devicel_id IS NOT NULL "
                + "ORDER BY ci.id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ContractItem item = new ContractItem();
                    item.setId(rs.getInt("ci_id"));
                    item.setStartAt(rs.getTimestamp("startAt"));
                    item.setEndDate(rs.getTimestamp("endDate"));

                    // Set created_at if available
                    if (rs.getTimestamp("ci_created_at") != null) {
                        java.time.OffsetDateTime odt = rs.getTimestamp("ci_created_at").toInstant()
                                .atOffset(java.time.ZoneOffset.UTC);
                        item.setCreatedAt(odt);
                    }

                    SubDevice sd = new SubDevice();
                    sd.setId(rs.getInt("sub_device_id"));
                    sd.setSeriId(rs.getString("seri_id"));

                    Device d = new Device();
                    d.setId(rs.getInt("device_id"));
                    d.setName(rs.getString("device_name"));
                    d.setImage(rs.getString("device_image"));
                    String maintenanceTime = rs.getString("maintenance_time");
                    d.setMaintenanceTime(maintenanceTime != null ? maintenanceTime : "0");
                    sd.setDevice(d);

                    item.setSubDevice(sd);

                    // Set contract (minimal info)
                    Contract contract = new Contract();
                    contract.setId(rs.getInt("contract_id"));
                    item.setContract(contract);

                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Insert maintenance request
    public boolean insertMaintenanceRequest(MaintanceRequest request) {

        String sql = "INSERT INTO maintenance_request "
                + "(title, content, image, user_id, status, contact_detail_id, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, request.getTitle());
            ps.setString(2, request.getContent());
            ps.setString(3, request.getImage());
            ps.setInt(4, request.getUser().getId());
            String statusValue = (request.getStatus() != null
                    ? request.getStatus().name()
                    : MaintenanceStatus.PENDING.name());
            ps.setString(5, statusValue);
            ps.setInt(6, request.getContractItem().getId());

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy contract item by id (để validate)
    public ContractItem getContractItemById(int contractItemId) {
        String sql = "SELECT ci.*, sd.seri_id, sd.id as sub_device_id, "
                + "d.name as device_name, d.id as device_id, d.image as device_image, "
                + "d.maintenance_time as maintenance_time, c.id as contract_id, c.user_id "
                + "FROM contract_item ci "
                + "INNER JOIN contract c ON ci.contract_id = c.id "
                + "INNER JOIN sub_device sd ON ci.sub_devicel_id = sd.id "
                + "INNER JOIN device d ON sd.device_id = d.id "
                + "WHERE ci.id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractItemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ContractItem item = new ContractItem();
                    item.setId(rs.getInt("id"));
                    item.setStartAt(rs.getTimestamp("startAt"));
                    item.setEndDate(rs.getTimestamp("endDate"));

                    SubDevice sd = new SubDevice();
                    sd.setId(rs.getInt("sub_device_id"));
                    sd.setSeriId(rs.getString("seri_id"));

                    Device d = new Device();
                    d.setId(rs.getInt("device_id"));
                    d.setName(rs.getString("device_name"));
                    d.setImage(rs.getString("device_image"));
                    d.setMaintenanceTime(String.valueOf(rs.getInt("maintenance_time")));
                    sd.setDevice(d);

                    item.setSubDevice(sd);

                    Contract contract = new Contract();
                    contract.setId(rs.getInt("contract_id"));
                    Users user = new Users();
                    user.setId(rs.getInt("user_id"));
                    contract.setUser(user);
                    item.setContract(contract);

                    return item;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void deleteMaintenanceRequest(String id) {
        String query = "delete FROM swp391.maintenance_request\n"
                + "where status = 0 and id =? ";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public MaintanceRequest getMaintanceRequestById(String id) {
        String query = "SELECT \n"
                + "    mr.id AS request_id,\n"
                + "    mr.title AS request_title,\n"
                + "    mr.content AS request_content,\n"
                + "    mr.status AS request_status,\n"
                + "    mr.image AS request_image,\n"
                + "    mr.created_at AS request_create_at\n"
                + "FROM maintenance_request mr\n"
                + "WHERE mr.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                MaintanceRequest mr = new MaintanceRequest();
                mr.setId(rs.getInt("request_id"));
                mr.setTitle(rs.getString("request_title"));
                mr.setContent(rs.getString("request_content"));
                mr.setImage(rs.getString("request_image"));
                String statusStr = rs.getString("request_status");
                if (statusStr != null) {
                    mr.setStatus(MaintenanceStatus.valueOf(statusStr));
                }
                java.sql.Timestamp timestamp = rs.getTimestamp("request_create_at");
                if (timestamp != null) {
                    mr.setCreatedAt(timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC));
                }
                return mr;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Users getUserByMaintenaneRequest(String id) {
        Users user = new Users();
        String query = "SELECT \n"
                + "    rmr.id AS reply_id,\n"
                + "    mr.id AS request_id,\n"
                + "    u.id AS user_id,\n"
                + "    u.displayname AS user_name\n"
                + "FROM swp391.reply_maintenance_request rmr\n"
                + "INNER JOIN swp391.maintenance_request mr ON rmr.maintenance_request_id = mr.id\n"
                + "INNER JOIN swp391._user u ON mr.user_id = u.id\n"
                + "WHERE mr.id = ?\n";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                MaintanceRequest mr = new MaintanceRequest();
                mr.setId(rs.getInt("request_id"));
                
                ReplyMaintanceRequest rmr = new ReplyMaintanceRequest();
                rmr.setId(rs.getInt("reply_id"));
                
                user.setId(rs.getInt("user_id"));
                user.setDisplayname(rs.getString("user_name"));
                
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Hàm đếm tổng số records để phân trang
    public int countTotalRequests(String keyword, String status, String fromDate, String toDate, int customerId) {
        String sql = "SELECT COUNT(*) FROM maintenance_request mr "
                + "JOIN _user u ON mr.user_id = u.id "
                + "JOIN contract_item ci ON mr.contact_detail_id = ci.id "
                + "JOIN sub_device sd ON ci.sub_devicel_id = sd.id "
                + "JOIN device d ON sd.device_id = d.id "
                + "WHERE 1=1 ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (mr.id LIKE ? OR u.displayname LIKE ? OR d.name LIKE ? OR sd.seri_id LIKE ? OR mr.content LIKE ?) ";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND mr.status = ? ";
        }
        if (customerId > 0) {
            sql += " AND mr.user_id = ? ";
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND mr.created_at >= ? ";
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND mr.created_at <= ? ";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                for (int i = 0; i < 5; i++) {
                    ps.setString(index++, "%" + keyword + "%");
                }
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (customerId > 0) {
                ps.setInt(index++, customerId);
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(index++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(index++, toDate);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Hàm tìm kiếm và lấy danh sách
    public List<MaintanceRequest> searchRequests(String keyword, String status, String fromDate, String toDate,
            int customerId, int pageIndex, int pageSize, String sortBy, String sortOrder) {
        List<MaintanceRequest> list = new ArrayList<>();

        // SQL Join để lấy thông tin chi tiết: Tên khách, Tên máy, Số seri
        String sql = "SELECT mr.*, u.displayname as customer_name, d.name as device_name, sd.seri_id "
                + "FROM maintenance_request mr "
                + "JOIN _user u ON mr.user_id = u.id "
                + "JOIN contract_item ci ON mr.contact_detail_id = ci.id "
                + "JOIN sub_device sd ON ci.sub_devicel_id = sd.id "
                + "JOIN device d ON sd.device_id = d.id "
                + "WHERE 1=1 ";

        // --- FILTER ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (mr.id LIKE ? OR u.displayname LIKE ? OR d.name LIKE ? OR sd.seri_id LIKE ? OR mr.content LIKE ?) ";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND mr.status = ? ";
        }
        if (customerId > 0) {
            sql += " AND mr.user_id = ? ";
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND mr.created_at >= ? ";
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND mr.created_at <= ? ";
        }

        // --- SORT ---
        String orderByCol = "mr.id"; // Mặc định
        if ("id".equalsIgnoreCase(sortBy)) {
            orderByCol = "mr.id";
        } else if ("customer".equalsIgnoreCase(sortBy)) {
            orderByCol = "u.displayname";
        } else if ("seri".equalsIgnoreCase(sortBy)) {
            orderByCol = "sd.seri_id";
        } else if ("content".equalsIgnoreCase(sortBy)) {
            orderByCol = "mr.content";
        }

        String direction = "ASC".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";
        sql += " ORDER BY " + orderByCol + " " + direction;

        // --- PAGING ---
        sql += " LIMIT ? OFFSET ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                for (int i = 0; i < 5; i++) {
                    ps.setString(index++, "%" + keyword + "%");
                }
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (customerId > 0) {
                ps.setInt(index++, customerId);
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(index++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(index++, toDate);
            }

            int offset = (pageIndex - 1) * pageSize;
            ps.setInt(index++, pageSize);
            ps.setInt(index++, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintanceRequest req = new MaintanceRequest();
                req.setId(rs.getInt("id"));
                req.setCreatedAt(rs.getObject("created_at", java.time.OffsetDateTime.class));
                req.setContent(rs.getString("content"));
                req.setImage(rs.getString("image"));
                String statusStr = rs.getString("status");
                if (statusStr != null) {
                    req.setStatus(MaintenanceStatus.valueOf(statusStr));
                }
                // Map User (Customer)
                Users u = new Users();
                u.setId(rs.getInt("user_id"));
                u.setDisplayname(rs.getString("customer_name"));
                req.setUser(u);

                // Map ContractItem -> SubDevice -> Device (Để lấy tên máy và seri)
                ContractItem ci = new ContractItem();
                ci.setId(rs.getInt("contact_detail_id"));

                SubDevice sd = new SubDevice();
                sd.setSeriId(rs.getString("seri_id"));

                Device d = new Device();
                d.setName(rs.getString("device_name"));

                sd.setDevice(d);
                ci.setSubDevice(sd);
                req.setContractItem(ci);

                list.add(req);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAllStatuses() {
        List<String> list = new ArrayList<>();
        // Chỉ lấy các status khác nhau, loại bỏ trùng lặp
        String sql = "SELECT DISTINCT status FROM maintenance_request WHERE status IS NOT NULL";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                if (status != null && !status.isEmpty()) {
                    list.add(status);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy maintenance request theo ID
    public MaintanceRequest getMaintenanceRequestById(int id) {
        String sql = "SELECT mr.*, u.displayname as customer_name, d.name as device_name, sd.seri_id, "
                + "d.id as device_id, d.image as device_image "
                + "FROM maintenance_request mr "
                + "JOIN _user u ON mr.user_id = u.id "
                + "JOIN contract_item ci ON mr.contact_detail_id = ci.id "
                + "JOIN sub_device sd ON ci.sub_devicel_id = sd.id "
                + "JOIN device d ON sd.device_id = d.id "
                + "WHERE mr.id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MaintanceRequest req = new MaintanceRequest();
                    req.setId(rs.getInt("id"));
                    req.setTitle(rs.getString("title"));
                    req.setContent(rs.getString("content"));
                    req.setImage(rs.getString("image"));
                    req.setCreatedAt(rs.getObject("created_at", java.time.OffsetDateTime.class));

                    String statusStr = rs.getString("status");
                    if (statusStr != null) {
                        req.setStatus(MaintenanceStatus.valueOf(statusStr));
                    }

                    // Map User
                    Users u = new Users();
                    u.setId(rs.getInt("user_id"));
                    u.setDisplayname(rs.getString("customer_name"));
                    req.setUser(u);

                    // Map ContractItem -> SubDevice -> Device
                    ContractItem ci = new ContractItem();
                    ci.setId(rs.getInt("contact_detail_id"));

                    SubDevice sd = new SubDevice();
                    sd.setSeriId(rs.getString("seri_id"));

                    Device d = new Device();
                    d.setId(rs.getInt("device_id"));
                    d.setName(rs.getString("device_name"));
                    d.setImage(rs.getString("device_image"));

                    sd.setDevice(d);
                    ci.setSubDevice(sd);
                    req.setContractItem(ci);

                    return req;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update maintenance request
    public boolean updateMaintenanceRequest(MaintanceRequest request) {
        String sql = "UPDATE maintenance_request SET title = ?, content = ?, image = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, request.getTitle());
            ps.setString(2, request.getContent());
            ps.setString(3, request.getImage());
            ps.setInt(4, request.getId());

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update maintenance request status
    public boolean updateMaintenanceRequestStatus(int requestId, MaintenanceStatus status) {
        String sql = "UPDATE maintenance_request SET status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, requestId);

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách replies theo maintenance request id
    public List<model.ReplyMaintanceRequest> getRepliesByRequestId(int requestId) {
        List<model.ReplyMaintanceRequest> list = new ArrayList<>();
        String sql = "SELECT rmr.*, mr.status as maintenance_status "
                + "FROM reply_maintenance_request rmr "
                + "INNER JOIN maintenance_request mr ON rmr.maintenance_request_id = mr.id "
                + "WHERE rmr.maintenance_request_id = ? ORDER BY rmr.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.ReplyMaintanceRequest reply = new model.ReplyMaintanceRequest();
                    reply.setId(rs.getInt("id"));
                    reply.setTitle(rs.getString("title"));
                    reply.setContent(rs.getString("content"));
                    reply.setCreatedAt(rs.getObject("created_at", java.time.OffsetDateTime.class));
                    
                    // Set maintenance request với status
                    model.MaintanceRequest maintanceRequest = new model.MaintanceRequest();
                    maintanceRequest.setId(requestId);
                    String statusStr = rs.getString("maintenance_status");
                    if (statusStr != null) {
                        try {
                            maintanceRequest.setStatus(utils.MaintenanceStatus.valueOf(statusStr));
                        } catch (IllegalArgumentException e) {
                            maintanceRequest.setStatus(utils.MaintenanceStatus.PENDING);
                        }
                    }
                    reply.setMaintanceRequest(maintanceRequest);
                    
                    list.add(reply);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm số yêu cầu bảo hành pending
    public int countPendingMaintenanceRequests() {
        String sql = "SELECT COUNT(*) FROM maintenance_request WHERE status = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, MaintenanceStatus.PENDING.name());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting pending maintenance requests: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

}

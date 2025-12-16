/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.time.OffsetDateTime;
import java.util.*;
import model.*;

/**
 *
 * @author ADMIN
 */
public class MaintenanceRequestDAO extends DBContext {

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
        String orderByCol = "mr.created_at"; // Mặc định
        if ("id".equalsIgnoreCase(sortBy)) {
            orderByCol = "mr.id";
        } else if ("customer".equalsIgnoreCase(sortBy)) {
            orderByCol = "u.displayname";
        } else if ("status".equalsIgnoreCase(sortBy)) {
            orderByCol = "mr.status";
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
                ps.setString(index++, fromDate + " 00:00:00");
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(index++, toDate + " 23:59:59");
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
                req.setStatus(rs.getString("status"));

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
}

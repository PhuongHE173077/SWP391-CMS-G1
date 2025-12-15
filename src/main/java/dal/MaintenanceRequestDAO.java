/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.*;

/**
 *
 * @author ADMIN
 */
public class MaintenanceRequestDAO extends DBContext{
    
//      public List<Contract> getMaintenanceRequest(String keyword, String sortBy, String sortOrder, int pageIndex, int pageSize, Integer userId) {
//        List<MaintanceRequest> lst = new ArrayList<>();
//        int offset = (pageIndex - 1) * pageSize;
//
//        String sql =  "select * from swp391.maintenance_request m";
// 
//        // THAM SỐ FILTER TRUYỀN VÀO
//          if (userId > 0) {
//            sql += " AND m.user_id = ?";
//        }
//        if (keyword != null && !keyword.trim().isEmpty()) {
//            sql += " AND m.content like ?";
//        }
//       
//        // SORT
//        // default khi hiện list là order by user Id
//        String listSort = " ORDER BY m.id ASC";
//        String orderCondition = "";
//        // SORT
//        // default khi hiện list là order by user Id
//        if (sortBy != null && !sortBy.isEmpty()) {
//            if ((sortOrder != null && sortOrder.equalsIgnoreCase("ASC"))) {
//                orderCondition = "ASC";
//            } else {
//                orderCondition = "DESC";
//            }
//        }
//
//        switch (sortBy) {
//            case "customer":
//                listSort = " ORDER BY u1.displayname " + orderCondition;
//                break;
//            case "id":
//                listSort = " ORDER BY c.id " + orderCondition;
//                break;
//        }
//
//        sql += listSort;
//        sql += " LIMIT ? OFFSET ?";
//        try {
//            PreparedStatement ps = connection.prepareStatement(sql);
//            int index = 1;
//            if (keyword != null && !keyword.trim().isEmpty()) {
//                ps.setString(index++, "%" + keyword + "%");
//                ps.setString(index++, "%" + keyword + "%");
//            }
//            if (createById > 0) {
//                ps.setInt(index++, createById);
//            }
//            ps.setInt(index++, pageSize);
//            ps.setInt(index++, offset);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                Contract c = new Contract();
//                c.setId(rs.getInt("id"));
//                c.setContent(rs.getString("content"));
//                c.setUrlContract(rs.getString("url_contract"));
//                c.setIsDelete(rs.getBoolean("isDelete"));
//                // Map Customer Name
//                Users customer = new Users();
//                customer.setId(rs.getInt("user_id"));
//                customer.setDisplayname(rs.getString("customer_name"));
//                c.setUser(customer);
//                // Map Creator Name
//                Users saleStaff = new Users();
//                saleStaff.setId(rs.getInt("createBy"));
//                saleStaff.setDisplayname(rs.getString("saleStaff_name"));
//                c.setCreateBy(saleStaff);
//                lst.add(c);
//            }
//        } catch (SQLException e) {
//            System.err.println("Error getting active contracts: " + e.getMessage());
//        }
//        return lst;
//    }
//    
}

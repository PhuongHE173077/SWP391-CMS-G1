/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import model.*;

/**
 *
 * @author ADMIN
 */
public class ContractDAO extends DBContext {

    public List<Contract> searchContracts(String keyword, String createById, String status, int pageIndex, int pageSize, String sortBy, String sortOrder) {
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
        if (createById != null && !createById.isEmpty()) {
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
            if (createById != null && !createById.isEmpty()) {
                try {
                    ps.setInt(index++, Integer.parseInt(createById));
                } catch (NumberFormatException | SQLException e) {
                    e.printStackTrace();
                    System.out.println("Lỗi: "+ e.getMessage());
                }
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
                Users creator = new Users();
                creator.setId(rs.getInt("createBy"));
                creator.setDisplayname(rs.getString("saleStaff_name"));
                c.setCreateBy(creator);
                lst.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lst;
    }

    // Hàm đếm tổng số bản ghi (Để chia trang)
    public int countContracts(String keyword, String status,  String createById) {
        String sql = "SELECT COUNT(*) FROM contract c "
                + "LEFT JOIN _user u1 ON c.user_id = u1.id "
                + "WHERE 1=1 ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (c.content LIKE ? OR u1.displayname LIKE ?) ";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND c.isDelete = ? ";
        }
           if (createById != null && !createById.isEmpty()) {
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
              if (createById != null && !createById.isEmpty()) {
                try {
                    ps.setInt(index++, Integer.parseInt(createById));
                } catch (NumberFormatException | SQLException e) {
                    e.printStackTrace();
                    System.out.println("Lỗi: "+ e.getMessage());
                }
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
    public void changeContractStatus(int id, int status){
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
        
        int count = dao.countContracts("", "", "");
        System.out.println(count);
     
    }

}

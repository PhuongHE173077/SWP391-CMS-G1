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
import model.ReplyMaintanceRequest;
import model.MaintanceRequest;

/**
 *
 * @author ADMIN
 */
public class ReplyMaintenanceRequestDAO extends DBContext {

    public List<ReplyMaintanceRequest> getAllReplyMaintanceRequest(String id) {
        List<ReplyMaintanceRequest> replyMaintanceRequest = new ArrayList<>();
        String query = "SELECT \n"
                + "    rmr.id AS reply_id,\n"
                + "    rmr.title AS reply_title,\n"
                + "    rmr.content AS reply_content,\n"
                + "    rmr.created_at AS reply_created_at,\n"
                + "    mr.id AS request_id\n"
                + "FROM swp391.reply_maintenance_request rmr\n"
                + "INNER JOIN swp391.maintenance_request mr ON rmr.maintenance_request_id = mr.id\n"
                + "WHERE mr.id = ? ORDER BY rmr.created_at ASC; ";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReplyMaintanceRequest rep = new ReplyMaintanceRequest();
                rep.setTitle(rs.getString("reply_title"));
                rep.setContent(rs.getString("reply_content"));
                java.sql.Timestamp timestamp = rs.getTimestamp("reply_created_at");
                if (timestamp != null) {
                    rep.setCreatedAt(timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC));
                }
                rep.setId(rs.getInt("reply_id"));

                MaintanceRequest maintanceRequest = new MaintanceRequest();
                maintanceRequest.setId(rs.getInt("request_id"));

                replyMaintanceRequest.add(rep);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return replyMaintanceRequest;
    }

    public void insertReplyMaintenanceRequest(ReplyMaintanceRequest rmr) {

        String query = " INSERT INTO swp391.reply_maintenance_request(created_at, content, title, maintenance_request_id)\n"
                + "VALUES (now(),?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, rmr.getContent());
            ps.setString(2, rmr.getTitle());
            ps.setInt(3, rmr.getMaintanceRequest().getId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

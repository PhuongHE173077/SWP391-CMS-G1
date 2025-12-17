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

public class MaintenanceRequestDAO extends DBContext {

    //Lấy tất cả contract items (sub-device có seri) đã được thêm vào hợp đồng của user    
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
        String sql = "INSERT INTO maintenance_request (content, user_id, status, contact_detail_id, created_at) "
                + "VALUES (?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, request.getContent());
            ps.setInt(2, request.getUser().getId());
            ps.setBoolean(3, request.getStatus() != null ? request.getStatus() : false);
            ps.setInt(4, request.getContractItem().getId());

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
                + "    rmr.id AS reply_id,\n"
                + "    mr.id AS request_id,\n"
                + "    mr.title AS request_title,\n"
                + "    mr.content AS request_content,\n"
                + "    mr.status AS request_status,\n"
                + "    mr.image AS request_image,\n"
                + "    mr.created_at AS request_create_at\n"
                + "FROM swp391.reply_maintenance_request rmr\n"
                + "INNER JOIN swp391.maintenance_request mr ON rmr.maintenance_request_id = mr.id\n"
                + "WHERE mr.id = ? ORDER BY rmr.created_at ASC; ";
        MaintanceRequest mr = new MaintanceRequest();
        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                mr.setTitle(rs.getString("request_title"));
                mr.setContent(rs.getString("request_content"));
                mr.setImage(rs.getString("request_image"));
                mr.setStatus(rs.getBoolean("request_status"));
                java.sql.Timestamp timestamp = rs.getTimestamp("request_create_at");
                if (timestamp != null) {
                    mr.setCreatedAt(timestamp.toInstant().atOffset(java.time.ZoneOffset.UTC));
                }
                mr.setId(rs.getInt("request_id"));

                ReplyMaintanceRequest replyMaintanceRequest = new ReplyMaintanceRequest();
                replyMaintanceRequest.setId(rs.getInt("reply_id"));
                return mr;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mr;
    }

}

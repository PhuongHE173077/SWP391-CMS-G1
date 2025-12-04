package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            String url = "jdbc:mysql://localhost:3306/SWP391?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String username = "root";

            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, username, password);

        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("LỖI KẾT NỐI MYSQL: " + ex.getMessage());
        }
    }
}

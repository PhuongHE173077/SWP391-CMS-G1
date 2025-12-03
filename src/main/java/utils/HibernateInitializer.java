package utils;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Listener tự động khởi tạo Hibernate khi ứng dụng start.
 * Hibernate sẽ tự động:
 * - Tạo bảng mới nếu có entity mới
 * - Cập nhật bảng nếu entity có thay đổi (hibernate.hbm2ddl.auto=update)
 */
@WebListener
public class HibernateInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== Khởi tạo Hibernate và cập nhật schema database ===");
        try {
            // Khởi tạo EntityManagerFactory - Hibernate sẽ tự động update schema
            JPAUtil.getEntityManagerFactory();
            System.out.println("=== Hibernate đã khởi tạo thành công! Schema đã được cập nhật. ===");
        } catch (Exception e) {
            System.err.println("=== LỖI khởi tạo Hibernate: " + e.getMessage() + " ===");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== Đóng Hibernate EntityManagerFactory ===");
        JPAUtil.shutdown();
    }
}

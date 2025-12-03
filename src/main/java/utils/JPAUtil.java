package utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Utility class để quản lý EntityManagerFactory.
 * Khi gọi getEntityManagerFactory() lần đầu, Hibernate sẽ tự động:
 * - Kiểm tra và tạo bảng mới nếu entity mới được thêm
 * - Cập nhật cấu trúc bảng nếu entity có thay đổi (thêm cột, sửa cột...)
 */
public class JPAUtil {

    private static final String PERSISTENCE_UNIT_NAME = "my_persistence_unit";
    private static EntityManagerFactory entityManagerFactory;

    /**
     * Lấy EntityManagerFactory (singleton pattern).
     * Khi được gọi lần đầu, Hibernate sẽ scan tất cả entity và update schema.
     */
    public static EntityManagerFactory getEntityManagerFactory() {
        if (entityManagerFactory == null) {
            entityManagerFactory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        }
        return entityManagerFactory;
    }

    /**
     * Lấy EntityManager mới để thực hiện các thao tác với database.
     */
    public static EntityManager getEntityManager() {
        return getEntityManagerFactory().createEntityManager();
    }

    /**
     * Đóng EntityManagerFactory khi ứng dụng shutdown.
     */
    public static void shutdown() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
        }
    }
}

package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.RolePermission;
import model.RouterGroup;
import model.Routers;
import model.Users;
import utils.RouterDefault;

/**
 * Filter để kiểm tra permission cho các URL trong RouterDefault
 * Nếu user không có quyền truy cập, sẽ redirect đến trang error
 */
@WebFilter(filterName = "PermissionFilter", urlPatterns = {"/*"})
public class PermissionFilter implements Filter {

    // Danh sách các URL không cần kiểm tra permission
    private static final List<String> EXCLUDED_URLS = new ArrayList<>();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo danh sách URL không cần kiểm tra permission
        EXCLUDED_URLS.add("/Login");
        EXCLUDED_URLS.add("/login.jsp");
        EXCLUDED_URLS.add("/LogOut");
        EXCLUDED_URLS.add("/ForgotPassword");
        EXCLUDED_URLS.add("/ResetPassword");
        EXCLUDED_URLS.add("/VerifyOtp");
        EXCLUDED_URLS.add("/error.jsp");
        EXCLUDED_URLS.add("/HomePage.jsp");
        EXCLUDED_URLS.add("/assets/");
        EXCLUDED_URLS.add("/css/");
        EXCLUDED_URLS.add("/js/");
        EXCLUDED_URLS.add("/images/");
        EXCLUDED_URLS.add("/img/");
        EXCLUDED_URLS.add(".css");
        EXCLUDED_URLS.add(".js");
        EXCLUDED_URLS.add(".jpg");
        EXCLUDED_URLS.add(".jpeg");
        EXCLUDED_URLS.add(".png");
        EXCLUDED_URLS.add(".gif");
        EXCLUDED_URLS.add(".ico");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Bỏ qua các URL không cần kiểm tra permission
        if (isExcludedUrl(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Lấy danh sách tất cả các router từ RouterDefault
        List<String> protectedUrls = getAllProtectedUrls();
        
        // Kiểm tra xem URL hiện tại có trong danh sách protected không
        if (!isProtectedUrl(path, protectedUrls)) {
            // URL không trong danh sách protected, cho phép truy cập
            chain.doFilter(request, response);
            return;
        }
        
        // URL trong danh sách protected, cần kiểm tra permission
        HttpSession session = httpRequest.getSession(false);
        
        // Nếu chưa đăng nhập và URL là protected, redirect đến login
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(contextPath + "/Login");
            return;
        }
        
        Users user = (Users) session.getAttribute("user");
        
        // Nếu user không có role, chặn truy cập
        if (user.getRoles() == null) {
            httpResponse.sendRedirect(contextPath + "/error.jsp");
            return;
        }
        
        int roleId = user.getRoles().getId();
        
        // Lấy danh sách rolePermissions từ session
        @SuppressWarnings("unchecked")
        List<RolePermission> rolePermissions = (List<RolePermission>) session.getAttribute("rolePermissions");
        
        if (rolePermissions == null) {
            // Nếu không có rolePermissions trong session, reload từ database
            dal.RolePermissionDAO rolePermissionDAO = new dal.RolePermissionDAO();
            rolePermissions = rolePermissionDAO.getRolePermission();
            session.setAttribute("rolePermissions", rolePermissions);
        }
        
        // Lấy path không có query string để so sánh
        String pathToCheck = path;
        if (path.contains("?")) {
            pathToCheck = path.substring(0, path.indexOf("?"));
        }
        
        // Kiểm tra xem user có quyền truy cập URL này không
        boolean hasPermission = false;
        for (RolePermission rp : rolePermissions) {
            if (rp.getRoles().getId() == roleId && rp.getRouter().equals(pathToCheck)) {
                hasPermission = true;
                break;
            }
        }
        
        if (!hasPermission) {
            // Không có quyền, redirect đến trang error
            httpResponse.sendRedirect(contextPath + "/error.jsp");
            return;
        }
        
        // Có quyền, cho phép truy cập
        chain.doFilter(request, response);
    }

    /**
     * Kiểm tra xem URL có trong danh sách excluded không
     */
    private boolean isExcludedUrl(String path) {
        if (path == null || path.isEmpty() || path.equals("/")) {
            return true;
        }
        
        // Bỏ query string để kiểm tra
        String pathToCheck = path;
        if (path.contains("?")) {
            pathToCheck = path.substring(0, path.indexOf("?"));
        }
        
        for (String excluded : EXCLUDED_URLS) {
            if (pathToCheck.startsWith(excluded) || pathToCheck.endsWith(excluded)) {
                return true;
            }
        }
        
        return false;
    }

    /**
     * Lấy tất cả các URL được bảo vệ từ RouterDefault
     */
    private List<String> getAllProtectedUrls() {
        List<String> protectedUrls = new ArrayList<>();
        
        // Lấy từ routerGroups (cho admin/manager)
        List<RouterGroup> routerGroups = RouterDefault.getRouterGroups();
        for (RouterGroup group : routerGroups) {
            for (Routers router : group.getRouterses()) {
                protectedUrls.add(router.getRouter());
            }
        }
        
        // Lấy từ routerGroupsForCus (cho customer)
        List<RouterGroup> routerGroupsForCus = RouterDefault.getRouterGroupsForCus();
        for (RouterGroup group : routerGroupsForCus) {
            for (Routers router : group.getRouterses()) {
                protectedUrls.add(router.getRouter());
            }
        }
        
        return protectedUrls;
    }

    /**
     * Kiểm tra xem URL có trong danh sách protected không
     */
    private boolean isProtectedUrl(String path, List<String> protectedUrls) {
        // Kiểm tra exact match
        if (protectedUrls.contains(path)) {
            return true;
        }
        
        // Kiểm tra với query string (bỏ qua phần sau ?)
        if (path.contains("?")) {
            String pathWithoutQuery = path.substring(0, path.indexOf("?"));
            if (protectedUrls.contains(pathWithoutQuery)) {
                return true;
            }
        }
        
        return false;
    }

    @Override
    public void destroy() {
        // Cleanup code nếu cần
    }
}


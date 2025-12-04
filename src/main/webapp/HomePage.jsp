<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                </div>
                    </div>

                </div>
                <i class="fas fa-chevron-down" style="color: #64748b; font-size: 12px;"></i>
            </div>
            <ul class="dropdown-menu dropdown-menu-end">
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/viewprofile.jsp">
                        <i class="fas fa-user me-2"></i>Xem hồ sơ
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/changepassword">
                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                    </a>
                </li>
                <li>
                    <hr class="dropdown-divider">
                </li>
                <li>
                    <a class="dropdown-item text-danger"
                       href="${pageContext.request.contextPath}/LogOut">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                    </a>
                </li>

            </ul>
        </div>
</div>
</header>

<!-- Page Content - Include your page content here -->
<main class="admin-content">
    <!-- Content will be placed here by the including page -->
</main>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
            function toggleSidebar() {
                const sidebar = document.getElementById('adminSidebar');
                const main = document.getElementById('adminMain');
                sidebar.classList.toggle('collapsed');
                main.classList.toggle('expanded');
            }

            // Set active nav link based on current URL
            document.addEventListener('DOMContentLoaded', function () {
                const currentPath = window.location.pathname;
                const navLinks = document.querySelectorAll('.nav-link');

                navLinks.forEach(link => {
                    if (currentPath.includes(link.getAttribute('href'))) {
                        link.classList.add('active');
                    }
                });
            });
</script>
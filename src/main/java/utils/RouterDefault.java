/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import model.RouterGroup;
import model.Routers;

/**
 *
 * @author admin
 */
public class RouterDefault {

    private static List<RouterGroup> routerGroups = new ArrayList<>();
    private static List<RouterGroup> routerGroupsForCus = new ArrayList<>();

    private static int idCounter = 1;

    public RouterDefault() {
    }

    static {
        initDefaultRouters();
        initCustomerRouters();
    }

    private static void initDefaultRouters() {
        addRouterGroup("Dashboard", Arrays.asList(
                new Routers("Xem Dashboard", "/Dashboard")));

        addRouterGroup("Quản lý danh mục thiết bị", Arrays.asList(
                new Routers("Xem danh mục", "/ViewListCategory"),
                new Routers("Thêm danh mục", "/AddCategory"),
                new Routers("Update thiết bị", "/UpdateCategory"),
                new Routers("Xóa thiết bị", "/delete_ViewListCategory")
        ));

        // Manage device
        addRouterGroup("Quản lý thiết bị", Arrays.asList(
                new Routers("Xem thiết bị", "/ViewListDevice"),
                new Routers("Thêm danh mục", "/AddDevice"),
                new Routers("Xem chi tiết thiết bị", "/ViewDetailDevice"),
                new Routers("Update thiết bị", "/EditDevice"),
                new Routers("Xóa thiết bị", "/DeleteDevice"),
                new Routers("Xem thiết bị con", "/ViewRemainingSubDevices"),
                new Routers("Thêm thiết bị con", "/AddSubDevice"),
                new Routers("Xóa hoàn toàn thiết bị con", "/DeleteSubDevice")
            ));
        
        addRouterGroup("Quản lý thiết bị đã xóa", Arrays.asList(
                new Routers("Xem thiết bị", "/ViewDeletedDevices"),
                new Routers("Khôi phục", "/Restore_DeleteDevices")
               ));

        addRouterGroup("Quản lý Hợp đồng", Arrays.asList(
                new Routers("Xem Hợp đồng", "/contract-list"),
                new Routers("Tạo hợp đồng", "/AddContract"),
                new Routers("Xem chi tiết Hợp đồng", "/contract-detail"),
                new Routers("Update Hợp đồng", "/update-contact")));

        addRouterGroup("Quản lý Hợp đồng đã xóa", Arrays.asList(
                new Routers("Xem Hợp đồng đã xóa", "/list-contract-delete"),
                new Routers("Khôi phục Hợp đồng", "/AddContract"),
                new Routers("Xóa hoàn toàn hợp đồng", "/contract-detail")));

        addRouterGroup("Quản lý yêu cầu bảo hành", Arrays.asList(
                new Routers("Xem yêu cầu bảo hành", "/seller-maintenance"),
                new Routers("Xem chi tiết và phản hồi", "/ViewDetaiRequestMaintance"),
                new Routers("Thay đổi trạng thái", "/UpdateRequestMaintance")));
    }

    private static void initCustomerRouters() {

        addRouterGroupForCustomer("Hợp đồng của tôi", Arrays.asList(
                new Routers("Xem danh sách hợp đồng", "/customer/ViewListContact"),
                new Routers("Chi tiết hợp đồng", "/customer/contract-detail")));

        addRouterGroupForCustomer("Yêu cầu bảo hành", Arrays.asList(
                new Routers("Danh sách yêu cầu", "/customer-maintenance"),
                new Routers("Tạo yêu cầu bảo hành", "/CreateRequestMaintance"),
                new Routers("Chi tiết yêu cầu", "/maintenance-detail")));

    }

    public static RouterGroup addRouterGroup(String name, List<Routers> routers) {
        RouterGroup group = new RouterGroup(idCounter++, name, new ArrayList<>(routers));
        routerGroups.add(group);
        return group;
    }

    public static RouterGroup addRouterGroupForCustomer(String name, List<Routers> routers) {
        RouterGroup group = new RouterGroup(idCounter++, name, new ArrayList<>(routers));
        routerGroupsForCus.add(group);
        return group;
    }

    public static List<RouterGroup> getRouterGroups() {
        return routerGroups;
    }

    public static List<RouterGroup> getRouterGroupsForCus() {
        return routerGroupsForCus;
    }

    public static String getRouterNameByPath(String routerPath) {
        for (RouterGroup group : routerGroups) {
            for (Routers router : group.getRouterses()) {
                if (router.getRouter().equals(routerPath)) {
                    return router.getName();
                }
            }
        }
        return routerPath;
    }

    public static String getGroupNameByRouterPath(String routerPath) {
        for (RouterGroup group : routerGroups) {
            for (Routers router : group.getRouterses()) {
                if (router.getRouter().equals(routerPath)) {
                    return group.getName();
                }
            }
        }
        return null;
    }

}

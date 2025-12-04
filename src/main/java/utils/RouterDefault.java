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
    private static int idCounter = 1;

    public RouterDefault() {
    }

    static {
        initDefaultRouters();
    }

    private static void initDefaultRouters() {

        // Manage Role
        addRouterGroup("Quản lý role", Arrays.asList(
                new Routers("Xem role", "/ViewRole"),
                new Routers("Xem chi tiết role", "/RoleDetail"),
                 new Routers("Update role", "/EditRole")
        ));
        
        // Manage device
        addRouterGroup("Quản lý thiết bị", Arrays.asList(
                new Routers("Xem thiết bị", "/ViewDevice"),
                new Routers("Xem chi tiết thiết bị", "/DeviceDetail"),
                new Routers("Update thiết bị", "/EditDevice")
        ));

    }

    public static RouterGroup addRouterGroup(String name, List<Routers> routers) {
        RouterGroup group = new RouterGroup(idCounter++, name, new ArrayList<>(routers));
        routerGroups.add(group);
        return group;
    }

    public static List<RouterGroup> getRouterGroups() {
        return routerGroups;
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

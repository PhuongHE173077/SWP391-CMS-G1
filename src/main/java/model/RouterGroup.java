/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author admin
 */
public class RouterGroup {
    
    private int id ;
    private  String name;
    private List<Routers>routerses;

    public RouterGroup(int id, String name, List<Routers> routerses) {
        this.id = id;
        this.name = name;
        this.routerses = routerses;
    }

    public RouterGroup() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Routers> getRouterses() {
        return routerses;
    }

    public void setRouterses(List<Routers> routerses) {
        this.routerses = routerses;
    }
    
    
}

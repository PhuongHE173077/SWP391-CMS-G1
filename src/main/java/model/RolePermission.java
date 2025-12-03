/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import utils.BaseEntity;

/**
 *
 * @author admin
 */
@Entity
@Table(name = "role_permission")
public class RolePermission extends BaseEntity{
    
    @Column(name = "router")
    private String router;
    
    @NotNull
    @ManyToOne
    @JoinColumn(name = "role_id", nullable = false) 
    private Roles roles;

    public RolePermission() {
    }

    public String getRouter() {
        return router;
    }

    public void setRouter(String router) {
        this.router = router;
    }

    public Roles getRoles() {
        return roles;
    }

    public void setRoles(Roles roles) {
        this.roles = roles;
    }
    
    
}

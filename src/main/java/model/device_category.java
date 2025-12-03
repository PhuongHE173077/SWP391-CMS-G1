/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import java.util.HashSet;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import utils.BaseEntity;
import java.util.Set;

/**
 *
 * @author admin
 */
@Entity
@Table(name="device_category")
public class device_category extends BaseEntity{
    
    @NotNull
    @Column(name="name")
    private String name;
    
    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    private Set<device> devices = new HashSet<>();

    public device_category() {
    }

    public device_category(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<device> getDevices() {
        return devices;
    }

    public void setDevices(Set<device> devices) {
        this.devices = devices;
    }
    
    
    
}

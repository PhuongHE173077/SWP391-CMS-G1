/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import java.util.HashSet;
import java.util.Set;
import utils.BaseEntity;

/**
 *
 * @author admin
 */
@Entity
@Table(name = "device")
public class Device extends BaseEntity {

    @Column(name = "image")
    private String image;

    @NotNull
    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description")
    private String description;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private DeviceCategory category;

    @Column(name = "maintaince_time")
    private String maintainceTime;

    @NotNull
    @Column(name = "isDelete", nullable = false)
    private boolean isDelete;

    @OneToMany(mappedBy = "device", fetch = FetchType.LAZY)
    private Set<SubDevice> subDevices = new HashSet<>();

    public Device() {
    }

    public Device(String image, String name, String description, DeviceCategory category, String maintainceTime,
            boolean isDelete) {
        this.image = image;
        this.name = name;
        this.description = description;
        this.category = category;
        this.maintainceTime = maintainceTime;
        this.isDelete = isDelete;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public DeviceCategory getCategory() {
        return category;
    }

    public void setCategory(DeviceCategory category) {
        this.category = category;
    }

    public String getMaintainceTime() {
        return maintainceTime;
    }

    public void setMaintainceTime(String maintainceTime) {
        this.maintainceTime = maintainceTime;
    }

    public boolean isIsDelete() {
        return isDelete;
    }

    public void setIsDelete(boolean isDelete) {
        this.isDelete = isDelete;
    }

    public Set<SubDevice> getSubDevices() {
        return subDevices;
    }

    public void setSubDevices(Set<SubDevice> subDevices) {
        this.subDevices = subDevices;
    }
}

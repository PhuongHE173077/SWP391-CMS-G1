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
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import utils.BaseEntity;

/**
 *
 * @author admin
 */
@Entity
@Table(name = "device")
public class device extends BaseEntity {

    @Column(name = "image")
    private String image;

    @NotNull
    @Column(name = "name")
    private String name;

    @Column(name = "description", columnDefinition = "text") 
    private String description;

    @NotNull
    @Column(name = "price")
    private Long price; 

    @NotNull
    @Column(name = "isDelete")
    private Boolean isDelete = false; 

    @Column(name = "maintaince_time")
    private String maintainceTime;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false) 
    private device_category category;

    public device(String image, String name, String description, Long price, String maintainceTime, device_category category) {
        this.image = image;
        this.name = name;
        this.description = description;
        this.price = price;
        this.maintainceTime = maintainceTime;
        this.category = category;
    }

    public device() {
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

    public Long getPrice() {
        return price;
    }

    public void setPrice(Long price) {
        this.price = price;
    }

    public Boolean getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(Boolean isDelete) {
        this.isDelete = isDelete;
    }

    public String getMaintainceTime() {
        return maintainceTime;
    }

    public void setMaintainceTime(String maintainceTime) {
        this.maintainceTime = maintainceTime;
    }

    public device_category getCategory() {
        return category;
    }

    public void setCategory(device_category category) {
        this.category = category;
    }
    
}

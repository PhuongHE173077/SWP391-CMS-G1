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
@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
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
}

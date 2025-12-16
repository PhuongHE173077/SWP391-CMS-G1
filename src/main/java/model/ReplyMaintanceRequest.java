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
import utils.BaseEntity;

/**
 *
 * @author admin
 */
@Entity
@Table(name = "reply_maintenance_request")
public class ReplyMaintanceRequest extends BaseEntity {
    @Column(name = "title")
    private String title;

    @Column(name = "content")
    private String content;

    @ManyToOne
    @JoinColumn(name = "maintenance_request_id")
    private MaintanceRequest maintanceRequest;

    public ReplyMaintanceRequest() {
    }

    public ReplyMaintanceRequest(String title, String content, MaintanceRequest maintanceRequest) {
        this.title = title;
        this.content = content;
        this.maintanceRequest = maintanceRequest;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public MaintanceRequest getMaintanceRequest() {
        return maintanceRequest;
    }

    public void setMaintanceRequest(MaintanceRequest maintanceRequest) {
        this.maintanceRequest = maintanceRequest;
    }
}

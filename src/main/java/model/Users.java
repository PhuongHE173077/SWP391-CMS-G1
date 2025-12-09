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

@Entity
@Table(name = "_user")
public class Users extends BaseEntity {

    @Column(name = "displayname")
    private String displayname;

    @Column(name = "email")
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "phone")
    private String phone;

    @Column(name = "active")
    private boolean active;

    @Column(name = "address")
    private String address;

    @Column(name = "gender")
    private boolean gender;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "role_id", nullable = false)
    private Roles roles;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<Contract> contracts = new HashSet<>();

    @OneToMany(mappedBy = "createBy", fetch = FetchType.LAZY)
    private Set<Contract> createdContracts = new HashSet<>();

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<MaintanceRequest> maintanceRequests = new HashSet<>();

    public Users(String displayname, String email, String password, String phone, boolean active, String address,
            boolean gender, Roles roles) {
        this.displayname = displayname;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.active = active;
        this.address = address;
        this.gender = gender;
        this.roles = roles;
    }

    public Users() {
    }

    public String getDisplayname() {
        return displayname;
    }

    public void setDisplayname(String displayname) {
        this.displayname = displayname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public Roles getRoles() {
        return roles;
    }

    public void setRoles(Roles roles) {
        this.roles = roles;
    }

    public Set<Contract> getContracts() {
        return contracts;
    }

    public void setContracts(Set<Contract> contracts) {
        this.contracts = contracts;
    }

    public Set<Contract> getCreatedContracts() {
        return createdContracts;
    }

    public void setCreatedContracts(Set<Contract> createdContracts) {
        this.createdContracts = createdContracts;
    }

    public Set<MaintanceRequest> getMaintanceRequests() {
        return maintanceRequests;
    }

    public void setMaintanceRequests(Set<MaintanceRequest> maintanceRequests) {
        this.maintanceRequests = maintanceRequests;
    }
}

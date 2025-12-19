/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Cascade
 */
public class CustomerStatistic {
    private int userId;
    private String displayName;
    private String email;
    private String phone;
    private int totalContracts;
    private int totalProducts;

    public CustomerStatistic() {
    }

    public CustomerStatistic(int userId, String displayName, String email, String phone, int totalContracts,
            int totalProducts) {
        this.userId = userId;
        this.displayName = displayName;
        this.email = email;
        this.phone = phone;
        this.totalContracts = totalContracts;
        this.totalProducts = totalProducts;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getTotalContracts() {
        return totalContracts;
    }

    public void setTotalContracts(int totalContracts) {
        this.totalContracts = totalContracts;
    }

    public int getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }
}

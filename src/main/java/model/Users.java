
package model;

public class Users {
    private int userId;
    private String displayname;
    private String email;
    private String password;
    private String phone;
    private boolean active;
    private int roleId;
    private String address;
    private boolean gender;

    public Users() {
    }

    public Users(int userId, String displayname, String email, String password, String phone, boolean active, int roleId, String address, boolean gender) {
        this.userId = userId;
        this.displayname = displayname;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.active = active;
        this.roleId = roleId;
        this.address = address;
        this.gender = gender;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
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
}

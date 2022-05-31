package com.ted.model;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "user", schema = "iii", catalog = "")
public class UserBean {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "user_id", nullable = false)
    private int userId;
    @Basic
    @Column(name = "user_account", nullable = false, length = 20)
    private String userAccount;
    @Basic
    @Column(name = "user_password", nullable = false, length = 50)
    private String userPassword;
    @Basic
    @Column(name = "user_role", nullable = false, length = 10)
    private String userRole;
    @Basic
    @Column(name = "user_email", nullable = true, length = 255)
    private String userEmail;
    @Basic
    @Column(name = "create_user", nullable = true, length = 10)
    private String createUser;
    @Basic
    @Column(name = "create_date", nullable = true)
    private Timestamp createDate;
    @Basic
    @Column(name = "update_user", nullable = true, length = 10)
    private String updateUser;
    @Basic
    @Column(name = "update_date", nullable = false)
    private Timestamp updateDate;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserAccount() {
        return userAccount;
    }

    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public Timestamp getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Timestamp updateDate) {
        this.updateDate = updateDate;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        UserBean that = (UserBean) o;

        if (userId != that.userId) return false;
        if (userAccount != null ? !userAccount.equals(that.userAccount) : that.userAccount != null) return false;
        if (userPassword != null ? !userPassword.equals(that.userPassword) : that.userPassword != null) return false;
        if (userRole != null ? !userRole.equals(that.userRole) : that.userRole != null) return false;
        if (userEmail != null ? !userEmail.equals(that.userEmail) : that.userEmail != null) return false;
        if (createUser != null ? !createUser.equals(that.createUser) : that.createUser != null) return false;
        if (createDate != null ? !createDate.equals(that.createDate) : that.createDate != null) return false;
        if (updateUser != null ? !updateUser.equals(that.updateUser) : that.updateUser != null) return false;
        if (updateDate != null ? !updateDate.equals(that.updateDate) : that.updateDate != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = userId;
        result = 31 * result + (userAccount != null ? userAccount.hashCode() : 0);
        result = 31 * result + (userPassword != null ? userPassword.hashCode() : 0);
        result = 31 * result + (userRole != null ? userRole.hashCode() : 0);
        result = 31 * result + (userEmail != null ? userEmail.hashCode() : 0);
        result = 31 * result + (createUser != null ? createUser.hashCode() : 0);
        result = 31 * result + (createDate != null ? createDate.hashCode() : 0);
        result = 31 * result + (updateUser != null ? updateUser.hashCode() : 0);
        result = 31 * result + (updateDate != null ? updateDate.hashCode() : 0);
        return result;
    }
}

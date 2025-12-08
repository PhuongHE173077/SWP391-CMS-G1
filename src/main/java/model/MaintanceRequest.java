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
@Table(name = "maintance_request")
public class MaintanceRequest extends BaseEntity {

    @Column(name = "content")
    private String content;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private Users user;

    @Column(name = "status")
    private Boolean status;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "contact_detail_id", nullable = false)
    private ContractItem contractItem;

    public MaintanceRequest() {
    }

    public MaintanceRequest(String content, Users user, Boolean status, ContractItem contractItem) {
        this.content = content;
        this.user = user;
        this.status = status;
        this.contractItem = contractItem;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public ContractItem getContractItem() {
        return contractItem;
    }

    public void setContractItem(ContractItem contractItem) {
        this.contractItem = contractItem;
    }
}

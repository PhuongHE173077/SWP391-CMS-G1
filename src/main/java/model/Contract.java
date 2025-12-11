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
@Table(name = "contract")
public class Contract extends BaseEntity {

    @NotNull
    @Column(name = "content", nullable = false)
    
    private String content;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private Users user;

    @Column(name = "url_contract")
    private String urlContract;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "createBy", nullable = false)
    private Users createBy;

    @NotNull
    @Column(name = "isDelete", nullable = false)
    private boolean isDelete;

    @OneToMany(mappedBy = "contract", fetch = FetchType.LAZY)
    private Set<ContractItem> contractItems = new HashSet<>();

    public Contract() {
    }

    public Contract(String content, Users user, String urlContract, Users createBy, boolean isDelete) {
        this.content = content;
        this.user = user;
        this.urlContract = urlContract;
        this.createBy = createBy;
        this.isDelete = isDelete;
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

    public String getUrlContract() {
        return urlContract;
    }

    public void setUrlContract(String urlContract) {
        this.urlContract = urlContract;
    }

    public Users getCreateBy() {
        return createBy;
    }

    public void setCreateBy(Users createBy) {
        this.createBy = createBy;
    }

    public boolean isIsDelete() {
        return isDelete;
    }

    public void setIsDelete(boolean isDelete) {
        this.isDelete = isDelete;
    }

    public Set<ContractItem> getContractItems() {
        return contractItems;
    }

    public void setContractItems(Set<ContractItem> contractItems) {
        this.contractItems = contractItems;
    }
}

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
@Table(name = "maintenance_request")
public class MaintanceRequest extends BaseEntity {
    
     @Column(name = "title")
    private String title;

    @Column(name = "content")
    private String content;
    
    @Column(name = "image")
    private String image;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private Users user;

    @Column(name = "status")
    private Boolean status;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "contact_detail_id", nullable = false)
    private ContractItem contractItem;

    @OneToMany(mappedBy = "maintanceRequest", fetch = FetchType.LAZY)
    private Set<ReplyMaintanceRequest> replyMaintanceRequests = new HashSet<>();

    public MaintanceRequest() {
    }

    public MaintanceRequest(String title, String content, String image, Users user, Boolean status, ContractItem contractItem) {
        this.title = title;
        this.content = content;
        this.image = image;
        this.user = user;
        this.status = status;
        this.contractItem = contractItem;
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

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
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

    public Set<ReplyMaintanceRequest> getReplyMaintanceRequests() {
        return replyMaintanceRequests;
    }

    public void setReplyMaintanceRequests(Set<ReplyMaintanceRequest> replyMaintanceRequests) {
        this.replyMaintanceRequests = replyMaintanceRequests;
    }
    
    

   
}

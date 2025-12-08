package model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;
import utils.BaseEntity;

/**
 *
 * @author admin
 */
@Entity
@Table(name = "contract_item")
public class ContractItem extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "sub_devicel_id")
    private SubDevice subDevice;

    @Column(name = "startAt")
    private Timestamp startAt;

    @Column(name = "endDate")
    private Timestamp endDate;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "contract_id", nullable = false)
    private Contract contract;

    @OneToMany(mappedBy = "contractItem", fetch = FetchType.LAZY)
    private Set<MaintanceRequest> maintanceRequests = new HashSet<>();

    public ContractItem() {
    }

    public ContractItem(SubDevice subDevice, Timestamp startAt, Timestamp endDate, Contract contract) {
        this.subDevice = subDevice;
        this.startAt = startAt;
        this.endDate = endDate;
        this.contract = contract;
    }

    public SubDevice getSubDevice() {
        return subDevice;
    }

    public void setSubDevice(SubDevice subDevice) {
        this.subDevice = subDevice;
    }

    public Timestamp getStartAt() {
        return startAt;
    }

    public void setStartAt(Timestamp startAt) {
        this.startAt = startAt;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public Contract getContract() {
        return contract;
    }

    public void setContract(Contract contract) {
        this.contract = contract;
    }

    public Set<MaintanceRequest> getMaintanceRequests() {
        return maintanceRequests;
    }

    public void setMaintanceRequests(Set<MaintanceRequest> maintanceRequests) {
        this.maintanceRequests = maintanceRequests;
    }
}

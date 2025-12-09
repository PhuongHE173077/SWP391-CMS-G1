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
@Table(name = "sub_device")
public class SubDevice extends BaseEntity {

    @NotNull
    @Column(name = "seri_id", nullable = false)
    private String seriId;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "device_id", nullable = false)
    private Device device;

    @NotNull
    @Column(name = "isDelete", nullable = false)
    private boolean isDelete;

    @OneToMany(mappedBy = "subDevice", fetch = FetchType.LAZY)
    private Set<ContractItem> contractItems = new HashSet<>();

    public SubDevice() {
    }

    public SubDevice(String seriId, Device device, boolean isDelete) {
        this.seriId = seriId;
        this.device = device;
        this.isDelete = isDelete;
    }

    public String getSeriId() {
        return seriId;
    }

    public void setSeriId(String seriId) {
        this.seriId = seriId;
    }

    public Device getDevice() {
        return device;
    }

    public void setDevice(Device device) {
        this.device = device;
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

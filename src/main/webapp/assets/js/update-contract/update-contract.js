// Khởi tạo dữ liệu từ server
const contractId = parseInt(document.getElementById('contractId').value);
const canEdit = document.getElementById('canEdit').value === 'true';

// Danh sách các item đã bị xóa (để gửi lên server)
let removedItemIds = [];

// Danh sách các sub device mới được thêm
let addedSubDevices = [];

// Danh sách serial hiện tại (để kiểm tra trùng)
let currentSerials = [];

// Danh sách sản phẩm đã xóa (pending) - để có thể search lại
let pendingRemovedDevices = [];

// Khởi tạo danh sách serial hiện tại
document.querySelectorAll('#contractItemsTable tr').forEach(row => {
    const serial = row.getAttribute('data-serial');
    if (serial) {
        currentSerials.push(serial);
    }
});

let subDeviceDebounceTimer;

// Search sub device
const searchInput = document.getElementById("searchSubDevice");
if (searchInput) {
    searchInput.addEventListener("input", function () {
        const query = this.value;
        clearTimeout(subDeviceDebounceTimer);
        subDeviceDebounceTimer = setTimeout(() => {
            searchSubDevice(query);
        }, 300);
    });
}

function searchSubDevice(query) {
    if (query.trim() === "") {
        document.getElementById("subDeviceResult").innerHTML = "";
        return;
    }

    fetch("/search-subdevice?serial=" + encodeURIComponent(query))
        .then(res => res.json())
        .then(data => {
            renderSubDeviceResult(data);
        })
        .catch(err => console.error("Search subdevice error:", err));
}

function renderSubDeviceResult(subDevices) {
    const list = document.getElementById("subDeviceResult");
    list.innerHTML = "";

    // Lọc bỏ những sản phẩm đã có trong danh sách hiện tại
    let filteredSubDevices = subDevices?.filter(subDevice =>
        !currentSerials.includes(subDevice.seriId)
    ) || [];

    // Thêm các sản phẩm đã xóa (pending) vào kết quả search nếu khớp
    const query = document.getElementById("searchSubDevice")?.value?.toLowerCase() || '';
    pendingRemovedDevices.forEach(pending => {
        if (pending.seriId.toLowerCase().includes(query) && !currentSerials.includes(pending.seriId)) {
            // Kiểm tra xem đã có trong filteredSubDevices chưa
            const exists = filteredSubDevices.some(sd => sd.seriId === pending.seriId);
            if (!exists) {
                filteredSubDevices.push({
                    id: pending.itemId, // Sử dụng itemId làm id tạm
                    seriId: pending.seriId,
                    device: pending.device,
                    isPendingRemoved: true // Đánh dấu là sản phẩm đã xóa pending
                });
            }
        }
    });

    if (filteredSubDevices.length === 0) {
        const li = document.createElement("li");
        li.className = "list-group-item text-muted";
        li.textContent = "Không tìm thấy thiết bị";
        list.appendChild(li);
        return;
    }

    filteredSubDevices.forEach(subDevice => {
        const li = document.createElement("li");
        li.className = "list-group-item list-group-item-action subdevice-item";

        li.innerHTML = `
            <div class="d-flex align-items-center">
                <img src="${subDevice.device?.image || 'https://sudospaces.com/phonglien-vn/2025/07/df36f4bc988f11d1489e-large.jpg'}" 
                     alt="Device" class="product-img border me-3">
                <div class="flex-grow-1">
                    <div class="product-name">${subDevice.device?.name || 'N/A'}</div>
                    <div class="serial-col">Số seri: ${subDevice.seriId}</div>
                    <small class="text-muted">Thời gian bảo hành: ${subDevice.device?.maintenanceTime || 'N/A'} tháng</small>
                </div>
            </div>
        `;

        li.onclick = () => selectSubDevice(subDevice);
        list.appendChild(li);
    });
}

function selectSubDevice(subDevice) {
    if (currentSerials.includes(subDevice.seriId)) {
        alert("Thiết bị này đã có trong hợp đồng!");
        return;
    }

    // Kiểm tra xem có phải sản phẩm đã xóa pending không
    const pendingIndex = pendingRemovedDevices.findIndex(p => p.seriId === subDevice.seriId);
    if (pendingIndex !== -1) {
        // Xóa khỏi danh sách pending và removedItemIds
        const pending = pendingRemovedDevices[pendingIndex];
        pendingRemovedDevices.splice(pendingIndex, 1);
        removedItemIds = removedItemIds.filter(id => id !== pending.itemId);
    }

    // Thêm vào danh sách
    currentSerials.push(subDevice.seriId);

    // Chỉ thêm vào addedSubDevices nếu không phải sản phẩm pending (đã có trong DB)
    if (pendingIndex === -1) {
        addedSubDevices.push({
            id: subDevice.id,
            seriId: subDevice.seriId,
            maintenanceTime: subDevice.device?.maintenanceTime || 0,
            device: subDevice.device
        });
    }

    addSubDeviceToTable(subDevice, pendingIndex !== -1);

    document.getElementById("subDeviceResult").innerHTML = "";
    document.getElementById("searchSubDevice").value = "";

    updateSummary();
}

function addSubDeviceToTable(subDevice, isRestored = false) {
    const tbody = document.getElementById("contractItemsTable");
    const rowCount = tbody.children.length + 1;

    const tr = document.createElement("tr");
    tr.setAttribute("data-serial", subDevice.seriId);

    // Nếu là sản phẩm restored từ pending, đánh dấu là existing item
    if (isRestored) {
        tr.setAttribute("data-item-id", subDevice.id || subDevice.itemId);
    } else {
        tr.setAttribute("data-new", "true");
    }

    const removeFunction = isRestored
        ? `removeExistingItem(${subDevice.id || subDevice.itemId}, '${subDevice.seriId}')`
        : `removeNewItem('${subDevice.seriId}')`;

    tr.innerHTML = `
        <td>${rowCount}</td>
        <td class="serial-col">${subDevice.seriId}</td>
        <td>
            <img src="${subDevice.device?.image || 'https://sudospaces.com/phonglien-vn/2025/07/df36f4bc988f11d1489e-large.jpg'}" 
                 alt="Product" class="product-img border">
        </td> 
        <td>
            <div class="product-name">${subDevice.device?.name || 'N/A'}</div>
            <span class="product-link"><i class="fas fa-arrow-right"></i></span>
        </td>
        <td>${subDevice.device?.maintenanceTime || 'N/A'} tháng</td>
        <td class="text-center">
            <button type="button" class="btn btn-sm btn-warning" onclick="${removeFunction}">Xóa</button>
        </td>
    `;

    tbody.appendChild(tr);
}

function removeExistingItem(itemId, seriId) {
    if (!confirm("Bạn có chắc muốn xóa sản phẩm này khỏi hợp đồng?")) {
        return;
    }

    // Lấy thông tin sản phẩm trước khi xóa để lưu vào pending
    const row = document.querySelector(`tr[data-item-id="${itemId}"]`);
    if (row) {
        const deviceName = row.querySelector('.product-name')?.textContent || 'N/A';
        const deviceImage = row.querySelector('.product-img')?.src || '';
        const maintenanceTime = row.querySelector('td:nth-child(5)')?.textContent?.replace(' tháng', '') || 'N/A';

        // Lưu vào danh sách pending để có thể search lại
        pendingRemovedDevices.push({
            itemId: itemId,
            seriId: seriId,
            device: {
                name: deviceName,
                image: deviceImage,
                maintenanceTime: maintenanceTime
            }
        });

        row.remove();
    }

    // Thêm vào danh sách cần xóa
    removedItemIds.push(itemId);

    // Xóa khỏi danh sách serial hiện tại
    currentSerials = currentSerials.filter(s => s !== seriId);

    reorderTableRows();
    updateSummary();
}

function removeNewItem(seriId) {
    // Xóa khỏi danh sách mới thêm
    addedSubDevices = addedSubDevices.filter(d => d.seriId !== seriId);

    // Xóa khỏi danh sách serial hiện tại
    currentSerials = currentSerials.filter(s => s !== seriId);

    // Xóa row khỏi table
    const row = document.querySelector(`tr[data-serial="${seriId}"][data-new="true"]`);
    if (row) {
        row.remove();
    }

    reorderTableRows();
    updateSummary();
}

function reorderTableRows() {
    const tbody = document.getElementById("contractItemsTable");
    const rows = tbody.querySelectorAll("tr");

    rows.forEach((row, index) => {
        row.querySelector("td:first-child").textContent = index + 1;
    });
}

function updateSummary() {
    const totalProducts = document.getElementById("totalProducts");
    const rowCount = document.querySelectorAll("#contractItemsTable tr").length;
    totalProducts.textContent = `${rowCount} sp`;
}

function setSubmitLoading(isLoading) {
    const overlay = document.getElementById("pageLoadingOverlay");
    const submitBtn = document.getElementById("submit-button");

    if (overlay) {
        overlay.classList.toggle("show", !!isLoading);
        overlay.setAttribute("aria-hidden", (!isLoading).toString());
    }

    if (submitBtn) {
        submitBtn.disabled = !!isLoading;
        if (isLoading) {
            submitBtn.dataset.originalText = submitBtn.dataset.originalText || submitBtn.textContent;
            submitBtn.textContent = "Đang cập nhật...";
        } else {
            const original = submitBtn.dataset.originalText;
            if (original) submitBtn.textContent = original;
        }
    }
}

function submitUpdate() {
    const rowCount = document.querySelectorAll("#contractItemsTable tr").length;
    if (rowCount === 0) {
        alert("Hợp đồng phải có ít nhất một sản phẩm");
        return;
    }

    // Kiểm tra xem có thay đổi gì không
    if (addedSubDevices.length === 0 && removedItemIds.length === 0) {
        alert("Không có thay đổi nào để cập nhật");
        return;
    }

    const updateData = {
        contractId: contractId,
        addedDevices: addedSubDevices,
        removedItemIds: removedItemIds
    };

    setSubmitLoading(true);
    fetch("/update-contract", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(updateData)
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert(data.message);
                window.location.href = "/contract-detail?id=" + contractId;
            } else {
                alert(data.message || "Có lỗi xảy ra");
            }
        })
        .catch(err => {
            console.error("Error updating contract:", err);
            alert("Có lỗi xảy ra khi cập nhật hợp đồng");
        })
        .finally(() => {
            setSubmitLoading(false);
        });
}

document.addEventListener("DOMContentLoaded", function () {
    const submitBtn = document.getElementById("submit-button");
    if (submitBtn) {
        submitBtn.addEventListener("click", submitUpdate);
    }
});

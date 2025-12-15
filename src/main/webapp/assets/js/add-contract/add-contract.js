const contextPath = window.contextPath;
let debounceTimer;
let subDeviceDebounceTimer;
let selectedSubDevices = [];
let selectedUserId = null;
let contentContract = "Máy phát điện được bảo hành ……… tháng kể từ ngày nghiệm thu, theo tiêu chuẩn của nhà sản xuất; Bên A chịu trách nhiệm sửa chữa, thay thế các lỗi kỹ thuật phát sinh không do lỗi của Bên B."

document.getElementById("searchUser").addEventListener("input", function () {
    const query = this.value;

    clearTimeout(debounceTimer);

    debounceTimer = setTimeout(() => {
        searchUser(query);
    }, 300);
});

document.getElementById("myText").value = contentContract;

document.getElementById("searchSubDevice").addEventListener("input", function () {
    const query = this.value;

    clearTimeout(subDeviceDebounceTimer);

    subDeviceDebounceTimer = setTimeout(() => {
        searchSubDevice(query);
    }, 300);
});

function searchUser(query) {
    if (query.trim() === "") {
        document.getElementById("userResult").innerHTML = "";
        return;
    }

    fetch("/search-user?keyword=" + encodeURIComponent(query))
        .then(res => res.json())
        .then(data => {

            renderUserResult(data);
        })
        .catch(err => console.error("Search user error:", err));
}

function renderUserResult(users) {
    const list = document.getElementById("userResult");
    list.innerHTML = "";

    if (!users || users.length === 0) {
        const li = document.createElement("li");
        li.className = "list-group-item text-muted cursor-pointer";
        li.textContent = "Không tìm thấy người dùng";
        list.appendChild(li);
        return;
    }

    users.forEach(u => {

        const li = document.createElement("li");
        li.className = "list-group-item list-group-item-action user-item";

        li.innerHTML = `
            <div class="user-info cursor-pointer">
                <div class="user-name">${u.displayname}</div>
                <div class="user-phone">${u.phone}</div>
            </div>
        `;

        li.onclick = () => selectUser(u);
        list.appendChild(li);
    });
}
function selectUser(u) {
    selectedUserId = u.id;

    const nameSpan = document.querySelector(".name");
    nameSpan.textContent = u.displayname;
    nameSpan.classList.remove('warning');

    const phoneSpan = document.querySelector(".phone")
    phoneSpan.textContent = u.phone;

    document.getElementById("userResult").innerHTML = "";

    document.getElementById("searchUser").value = "";
}

function searchSubDevice(query) {
    if (query.trim() === "") {
        document.getElementById("subDeviceResult").innerHTML = "";
        return;
    }

    fetch("/search-subdevice?serial=" + encodeURIComponent(query))
        .then(res => res.json())
        .then(data => {
            console.log(data);
            renderSubDeviceResult(data);
        })
        .catch(err => console.error("Search subdevice error:", err));
}

function renderSubDeviceResult(subDevices) {
    const list = document.getElementById("subDeviceResult");
    list.innerHTML = "";

    const filteredSubDevices = subDevices?.filter(subDevice =>
        !selectedSubDevices.find(d => d.seriId === subDevice.seriId)
    ) || [];

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

    if (selectedSubDevices.find(d => d.seriId === subDevice.seriId)) {
        alert("Thiết bị này đã được thêm vào danh sách!");
        return;
    }

    selectedSubDevices.push(subDevice);
    addSubDeviceToTable(subDevice);

    document.getElementById("subDeviceResult").innerHTML = "";
    document.getElementById("searchSubDevice").value = "";

    updateSummary();
}

function addSubDeviceToTable(subDevice) {
    const tbody = document.querySelector(".table tbody");
    const rowCount = tbody.children.length + 1;

    const tr = document.createElement("tr");
    tr.setAttribute("data-serial", subDevice.seriId);

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
            <button type="button" class="btn btn-sm btn-warning" onclick="removeSubDevice('${subDevice.seriId}')">Xóa</button>
        </td>
    `;

    tbody.appendChild(tr);
}

function removeSubDevice(seriId) {

    selectedSubDevices = selectedSubDevices.filter(d => d.seriId !== seriId);

    const row = document.querySelector(`tr[data-serial="${seriId}"]`);
    if (row) {
        row.remove();
    }

    reorderTableRows();

    updateSummary();
}

// Reorder Table Rows (STT column)
function reorderTableRows() {
    const tbody = document.querySelector(".table tbody");
    const rows = tbody.querySelectorAll("tr");

    rows.forEach((row, index) => {
        row.querySelector("td:first-child").textContent = index + 1;
    });
}

// Update Summary
function updateSummary() {
    const summaryValue = document.querySelector(".summary-value");
    summaryValue.textContent = `${selectedSubDevices.length} sp`;
}

// Clear selected user
function clearUser() {
    selectedUserId = null;
    const nameSpan = document.querySelector(".name");
    nameSpan.textContent = "Chưa có thông tin";
    nameSpan.classList.add('warning');

    const phoneSpan = document.querySelector(".phone");
    phoneSpan.textContent = "";
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
            submitBtn.textContent = "Đang tạo...";
        } else {
            const original = submitBtn.dataset.originalText;
            if (original) submitBtn.textContent = original;
        }
    }
}


function submitContract() {

    if (!selectedUserId) {
        alert("Vui lòng chọn khách hàng");
        return;
    }

    if (selectedSubDevices.length === 0) {
        alert("Vui lòng chọn ít nhất một thiết bị");
        return;
    }

    const content = document.getElementById("myText").value;
    if (!content.trim()) {
        alert("Vui lòng nhập nội dung hợp đồng");
        return;
    }

    const contractData = {
        userId: selectedUserId,
        content: content,
        subDevices: selectedSubDevices
    };

    setSubmitLoading(true);
    fetch("/AddContract", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(contractData)
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert(data.message);

                clearUser();
                selectedSubDevices = [];
                document.querySelector(".table tbody").innerHTML = "";
                document.getElementById("myText").value = contentContract;
                updateSummary();
            } else {
                alert(data.message || "Có lỗi xảy ra");
            }
        })
        .catch(err => {
            console.error("Error creating contract:", err);
            alert("Có lỗi xảy ra khi tạo hợp đồng");
        })
        .finally(() => {
            setSubmitLoading(false);
        });
}


// Function to select customer (called from popover after creating new customer)
function selectCustomer(customer) {
    if (customer && customer.id) {
        selectUser({
            id: customer.id,
            displayname: customer.name,
            phone: customer.phone
        });
    }
}

document.addEventListener("DOMContentLoaded", function () {

    const clearUserBtn = document.querySelector(".btn-link.text-danger");
    if (clearUserBtn) {
        clearUserBtn.addEventListener("click", clearUser);
    }


    const submitBtn = document.querySelector("#submit-button");
    if (submitBtn) {
        submitBtn.addEventListener("click", submitContract);
    }

    // Initialize popover for adding new customer
    const addCustomerBtn = document.getElementById('addCustomerBtn');
    if (addCustomerBtn) {
        const popoverContentEl = document.getElementById('createCustomerPopover');
        const popoverContent = popoverContentEl ? popoverContentEl.innerHTML : '';

        const popover = new bootstrap.Popover(addCustomerBtn, {
            content: popoverContent,
            sanitize: false,
            trigger: 'click'
        });


        addCustomerBtn.addEventListener('shown.bs.popover', function () {
            const cancelBtn = document.getElementById('cancelCreateCustomer');
            const form = document.getElementById('createCustomerForm');

            if (cancelBtn) {
                cancelBtn.addEventListener('click', function () {
                    popover.hide();
                });
            }

            if (form) {
                form.addEventListener('submit', function (e) {
                    e.stopPropagation();

                    const name = document.getElementById('newCustomerName').value.trim();
                    const phone = document.getElementById('newCustomerPhone').value.trim();
                    const email = document.getElementById('newCustomerEmail').value.trim();
                    const address = document.getElementById('newCustomerAddress').value.trim();

                    if (!name || !phone || !email) {
                        alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                        return;
                    }


                    fetch('/AddCustomer', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            name: name,
                            phone: phone,
                            email: email,
                            address: address
                        })
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                alert('Tạo tài khoản thành công!');
                                popover.hide();
                                // Optionally auto-select the new customer
                                if (data.customer) {
                                    selectCustomer(data.customer);
                                }
                            } else {
                                alert(data.message || 'Có lỗi xảy ra!');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Có lỗi xảy ra khi tạo tài khoản!');
                        });
                });
            }
        });

        // Close popover when clicking outside
        document.addEventListener('click', function (e) {
            if (!addCustomerBtn.contains(e.target) && !document.querySelector('.popover')?.contains(e.target)) {
                popover.hide();
            }
        });
    }
});

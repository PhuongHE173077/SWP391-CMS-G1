const contextPath = window.contextPath;
let debounceTimer;

document.getElementById("searchUser").addEventListener("input", function () {
    const query = this.value;

    clearTimeout(debounceTimer);

    debounceTimer = setTimeout(() => {
        searchUser(query);
    }, 300);
});

 document.getElementById("myText").value = "Máy phát điện được bảo hành ……… tháng kể từ ngày nghiệm thu, theo tiêu chuẩn của nhà sản xuất; Bên A chịu trách nhiệm sửa chữa, thay thế các lỗi kỹ thuật phát sinh không do lỗi của Bên B.";

function searchUser(query) {
    if (query.trim() === "") {
        document.getElementById("userResult").innerHTML = "";
        return;
    }

    fetch(contextPath + "/search-user?keyword=" + encodeURIComponent(query))
        .then(res => res.json())
        .then(data => {
            console.log(data);
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
    const nameSpan = document.querySelector(".name");
    nameSpan.textContent = u.displayname;
    nameSpan.classList.remove('warning');
    
    const phoneSpan = document.querySelector(".phone")
    phoneSpan.textContent = u.phone;

    document.getElementById("userResult").innerHTML = "";

    document.getElementById("searchUser").value = "";
}

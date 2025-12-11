<%-- Document : editprofile Created on : Dec 4, 2025, 9:10:47 AM Author : Dell --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Chỉnh sửa thông tin cá nhân</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background: #f4f4f4;
                    padding: 20px;
                }

                h2 {
                    text-align: center;
                }

                form {
                    width: 350px;
                    background: white;
                    padding: 20px;
                    margin: 0 auto;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }

                form input[type="text"],
                form input[type="email"] {
                    width: 100%;
                    padding: 8px;
                    margin: 8px 0;
                    border: 1px solid #ccc;
                    border-radius: 5px;
                }

                .gender-group {
                    margin: 10px 0;
                    display: flex;
                    gap: 15px;
                    align-items: center;
                }

                input[type="submit"] {
                    width: 100%;
                    padding: 10px;
                    background: blue;
                    color: white;
                    font-size: 16px;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                }



                .error {
                    color: red;
                    text-align: center;
                    margin-top: 15px;
                }

                .phone-error {
                    color: red;
                    font-size: 12px;
                    margin-top: 4px;
                    display: none;
                }

                input.invalid {
                    border-color: red;
                }

                input.valid {
                    border-color: green;
                }

                label {
                    display: block;
                    margin-top: 10px;
                    font-weight: bold;
                }
            </style>

        </head>

        <body>
            <form action="EditProfile" method="post">
                <div style="margin-top:15px;">
                    <a href="ViewProfile" style="
                   
                   padding:10px 10px;
                   background: blue;
                   color:white;
                   text-decoration:none;
                   border-radius:5px;
                   ">
                        Quay lại
                    </a>
                </div>
                <h2>Chỉnh sửa thông tin cá nhân</h2>
                <input type="hidden" name="id" value="${user.id}">

                <label>Họ và tên:</label>
                <input type="text" name="displayname" value="${user.displayname}" required>

                <label>Email:</label>
                <input type="email" name="email" value="${user.email}" required>

                <label>Số điện thoại:</label>
                <input type="text" name="phone" id="phone" value="${user.phone}" pattern="^0[0-9]{9}$" maxlength="10"
                    placeholder="0123456789" required>
                <div class="phone-error" id="phoneError"></div>

                <label>Địa chỉ:</label>
                <input type="text" name="address" value="${user.address}" required>

                <div class="gender-group">
                    <label>Giới tính:</label>
                    <label><input type="radio" name="gender" value="male" ${user.gender ? "checked" : "" } required>
                        Male</label>
                    <label><input type="radio" name="gender" value="female" ${!user.gender ? "checked" : "" } required>
                        Female</label>
                </div>


                <input type="submit" value="Cập nhật">

            </form>

            <p class="error">${error}</p>

            <script>
                const phoneInput = document.getElementById('phone');
                const phoneError = document.getElementById('phoneError');

                phoneInput.addEventListener('input', function (e) {
                    // Xóa tất cả ký tự không phải số
                    this.value = this.value.replace(/[^0-9]/g, '');

                    if (this.value.length > 0 && this.value[0] !== '0') {
                        this.value = '0' + this.value.replace(/^0+/, '');
                    }

                    if (this.value.length > 10) {
                        this.value = this.value.substring(0, 10);
                    }

                    validatePhone();
                });

                phoneInput.addEventListener('blur', function () {
                    validatePhone();
                });

                document.querySelector('form').addEventListener('submit', function (e) {
                    if (!validatePhone()) {
                        e.preventDefault();
                        return false;
                    }
                });

                function validatePhone() {
                    const phone = phoneInput.value.trim();
                    let isValid = true;
                    let errorMessage = '';
                    
                    if (phone === '') {
                        errorMessage = 'Số điện thoại không được để trống!';
                        isValid = false;
                    }
                    else if (phone[0] !== '0') {
                        errorMessage = 'Số điện thoại phải bắt đầu bằng số 0!';
                        isValid = false;
                    }
                    else if (phone.length !== 10) {
                        errorMessage = 'Số điện thoại phải có đúng 10 số!';
                        isValid = false;
                    }
                    else if (!/^[0-9]+$/.test(phone)) {
                        errorMessage = 'Số điện thoại chỉ được chứa số!';
                        isValid = false;
                    }

                    if (!isValid) {
                        phoneError.textContent = errorMessage;
                        phoneError.style.display = 'block';
                        phoneInput.classList.remove('valid');
                        phoneInput.classList.add('invalid');
                    } else {
                        phoneError.style.display = 'none';
                        phoneInput.classList.remove('invalid');
                        phoneInput.classList.add('valid');
                    }

                    return isValid;
                }

                if (phoneInput.value) {
                    validatePhone();
                }
            </script>
        </body>

        </html>
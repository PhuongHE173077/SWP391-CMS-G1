<!DOCTYPE html>
<html lang="vi">



    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            /* Reset */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: Arial, sans-serif;
            }

            body {
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                background: linear-gradient(135deg, #4e54c8, #8f94fb);
            }

            .login-container {
                width: 360px;
                background: rgba(255, 255, 255, 0.15);
                padding: 40px 30px;
                border-radius: 15px;
                backdrop-filter: blur(10px);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                color: #fff;
            }

            .login-box .title {
                font-size: 32px;
                font-weight: bold;
                text-align: center;
                margin-bottom: 10px;
            }

            .login-box .subtitle {
                text-align: center;
                opacity: 0.9;
                margin-bottom: 25px;
            }

            .text-danger {
                color: #ffcccc;
                text-align: center;
                margin-bottom: 10px;
            }

            .input-group {
                margin-bottom: 15px;
            }

            .input-group input {
                width: 100%;
                padding: 12px;
                border-radius: 8px;
                border: none;
                outline: none;
                font-size: 15px;
            }

            .password-field {
                position: relative;
            }

            .password-toggle {
                position: absolute;
                right: 10px;
                top: 12px;
                cursor: pointer;
                font-size: 18px;
                color: #333;
            }

            .forgot-password {
                display: block;
                text-align: center;
                margin-top: 5px;
                font-size: 14px;
                color: #fff;
                text-decoration: none;
                opacity: 0.9;
            }

            .forgot-password:hover {
                text-decoration: underline;
            }

            .sign-in-button {
                width: 100%;
                margin-top: 20px;
                padding: 12px;
                background: #fff;
                border: none;
                border-radius: 8px;
                font-size: 18px;
                font-weight: bold;
                cursor: pointer;
                transition: 0.3s;
                color: #4e54c8;
            }

            .sign-in-button:hover {
                background: #e6e6e6;
            }

            .create-account {
                text-align: center;
                margin-top: 20px;
                color: #fff;
            }

            .create-account a {
                color: #fff;
                font-weight: bold;
            }
        </style>

    </head>

    <body>

        <div class="login-container">
            <div class="login-box">

                <h1 class="title">Sign In</h1>
                <p class="subtitle">Enter your credentials to continue</p>

                <p class="text-danger"> ${mess} </p>
                <p class="text-danger"> ${messdie} </p>

                <form action="/Login" method="POST">

                    <div class="input-group">
                        <input type="email" id="email" name="email" placeholder="Email" required>
                    </div>

                    <div class="input-group password-field">
                        <input type="password" id="password" name="password" placeholder="Password" required>
                        <span class="password-toggle">
                            <i class="fa-solid fa-eye" id="togglePassword"></i>
                        </span>
                    </div>

                    <a href="ForgotPassword" class="forgot-password">Forgot password</a>

                    <button type="submit" class="sign-in-button">Sign In</button>                 

                </form>
            </div>
        </div>  
        <script>
            const togglePassword = document.getElementById("togglePassword");
            const passwordInput = document.getElementById("password");

            togglePassword.addEventListener("click", function () {


                const currentType = passwordInput.getAttribute("type");
                passwordInput.setAttribute("type", currentType === "password" ? "text" : "password");

                // ??i icon
                this.classList.toggle("fa-eye");
                this.classList.toggle("fa-eye-slash");
            });
        </script>

    </body>

</html>

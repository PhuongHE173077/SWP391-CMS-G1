<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>

    <div class="login-container">
        <div class="login-box">

            <h1 class="title">Sign In</h1>
            <p class="subtitle">Enter your credentials to continue</p>
            <p class="text-danger"> ${mess} </p>
            <p class="text-danger"> ${messdie} </p>
            <form href="/Login" method="POST">

                <div class="input-group">
                    <input type="email" id="email" name="email" placeholder="Email" required>
                </div>

                <div class="input-group password-field">
                    <input type="password" id="password" name="password" placeholder="Password" required>
                    <span class="password-toggle">

                    </span>
                </div>

                <a href="#" class="forgot-password">Forgot password?</a>
        </div>

        <button type="submit" class="sign-in-button">Sign In</button>

        <p class="create-account">
            Don't have an account? <a href="#">Create one</a>
        </p>
        </form>
    </div>
    </div>



</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja" class="auth-page">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8" />
    <title>ログイン・会員登録 | CAL_EC site</title>
    <link rel="stylesheet" href="styles/u_login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" integrity="sha512-1sCRPdkRXhBV2PBLUdRb4tMg1w2YPf37qatUFeS7zlBy7jJI8Lf4VHwWfZZfpXtYSLy85pkm9GaYVYMfw5BC1A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
</head>
<body class="auth-page">
<% String registered = request.getParameter("registered"); %>
<% if ("success".equals(registered)) { %>
<script>
    alert("登録が完了しました。");
</script>
<% } %>

		<div class="cal-logo">
		  <img src="image/logo-cal.png" alt="CAL Logo">
		</div>
		
		

<!--        code the dark mode-->
        <div class="header-controls">
            <div class="btn" id="themeToggle">
			  <div class="btn__indicator">
			    <div class="btn__icon-container">
			      <i class="btn__icon fa-solid"></i>
			    </div>
			  </div>
			</div>
        </div>
    
    <%
    String lang = (String) session.getAttribute("lang");
    if (lang == null) lang = "ja";
%>

    <!-- Main Container -->
    <div class="auth-container">
        <!-- Authentication Forms -->
        <div class="auth-forms-wrapper">
            <div class="auth-slider" id="authSlider">
                
                <!-- Login Panel -->
                <div class="auth-panel active" id="loginPanel">
                    <div class="panel-content">
<!--                    language button-->
					<div class="language-switcher">
						<form action="change-language" method="get">
							<label for="lang" class="lang-label"><%= "ja".equals(lang) ? "🌐 言語選択" : "🌐 Language:" %></label>
								<select name="lang" id="lang" class="lang-select" onchange="this.form.submit()">
									<option value="ja" <%= "ja".equals(session.getAttribute("lang")) ? "selected" : "" %>>🇯🇵 日本語</option>
									<option value="en" <%= "en".equals(session.getAttribute("lang")) ? "selected" : "" %>>🇺🇸 English</option>
								</select>
						</form>
					</div>

<!--                    h2-->
						<div class="panel-header">
							<h2 class="panel-title">
								<%= "ja".equals(lang) ? "ようこそ!" : "Welcome!" %>
							</h2>
						</div>
						
						<!-- Error Message Display -->
                            <% 
                                String errorMsg = (String) request.getAttribute("errorMsg");
                                if (errorMsg != null) {
                            %>
                                <div class="error-message show">
                                    <span class="error-icon">⚠️</span>
                                    <span class="error-text"><%= "ja".equals(lang) ? errorMsg : "The user ID or password is incorrect." %></span>
                                    <button type="button" class="error-close" onclick="hideErrorMessage(this)">✕</button>
                                </div>
                            <% } %>

                        <!-- Login Form -->
                        <form action="login-servlet" method="post" class="auth-form" id="loginForm">
                            <div class="form-group">
                                <div class="input-wrapper">
                                	<ion-icon name="person-outline" class="icons"></ion-icon>
                                    <input type="text" name="userId" placeholder="<%= "ja".equals(lang) ? "ユーザーIDを入力してください" : "Please enter your user ID" %>" required class="form-input" id="loginUserId">
                                    <div class="input-focus-line"></div>
                                </div>
                                <div class="input-feedback" id="loginUserIdFeedback"></div>
                            </div>

                            <div class="form-group">
                                <div class="input-wrapper">
                                <ion-icon name="lock-closed-outline" class="icons"></ion-icon>
                                    <input type="password" name="password" placeholder="<%= "ja".equals(lang) ? "パスワードを入力してください" : "Please enter your password" %>" required class="form-input" id="loginPassword">
									<button type="button" class="password-toggle" onclick="passwordToggles(this)">
									  <ion-icon name="eye-off-outline" class="toggle-icon"></ion-icon>
									</button>
                                    <div class="input-focus-line"></div>
                                </div>
                                <div class="input-feedback" id="loginPasswordFeedback"></div>
                            </div>

                            <div class="form-options">
                                <label class="checkbox-wrapper">
                                    <input type="checkbox" name="remember" class="checkbox-input">
                                    <span class="checkbox-text"><%= "ja".equals(lang) ? "ログイン状態を保持する" : "Stay signed in" %></span>
                                </label>
                            </div>

                            <button type="submit" class="auth-submit-btn" id="loginSubmitBtn">
                                <span class="btn-text"><%= "ja".equals(lang) ? "ログイン" : "Login" %></span>
                            </button>
                        </form>

                        <div class="panel-footer">
                                <a href="u_register.jsp" class="switch-panel-btn">
						            <button><%= "ja".equals(lang) ? "アカウント作成" : "Register" %></button>
						        </a>
                        </div>
                        
                        <div class="forgot-pass">
                        	<p><%= "ja".equals(lang) ? "パスワード忘れた方は" : "Forgot your password" %><a href="#"><%= "ja".equals(lang) ? "こちらへ" : "Click here" %></a></p>
                        </div>
                        
                        <div class="codetheworld-io">
                        	<a href="#" style="--color: #00C300">
                        		<i class="fa-brands fa-line"></i>
                        	</a>
                        	<a href="#" style="--color: #E1306C">
                        		<i class="fa-brands fa-instagram"></i>
                        	</a>
                        	<a href="#" style="--color: #FF0050">
                        		<i class="fa-brands fa-tiktok"></i>
                        	</a>
                        	<a href="#" style="--color: #4267B2">
                        		<i class="fa-brands fa-facebook"></i>
                        	</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
     </div>
     
     <footer class="signup-footer">
        <div class="footer-links">
            <a href="HTML/help.html" target="_blank" class="footer-link"><%= "ja".equals(lang) ? "ヘルプ" : "Help" %></a>
            <a href="HTML/privacy.html" target="_blank" class="footer-link"><%= "ja".equals(lang) ? "プライバシー" : "Privacy" %></a>
            <a href="HTML/terms.html" target="_blank" class="footer-link"><%= "ja".equals(lang) ? "利用規約" : "Terms of Service" %></a>
            <a href="HTML/contact.html" target="_blank" class="footer-link"><%= "ja".equals(lang) ? "お問い合わせ" : "Contact" %></a>
            <a href="HTML/about.html" target="_blank" class="footer-link"><%= "ja".equals(lang) ? "会社情報" : "About Us" %></a>
        </div>
    </footer>
                
    <script>
		function hideErrorMessage(button) {
		    // ボタンの親要素であるエラーメッセージの<div>を非表示にする
		    const errorDiv = button.parentElement;
		    errorDiv.style.display = "none";
		}
	</script>
         

    <!-- Scripts -->
    <script src="JavaScript/login.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
	<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    
</body>
</html>
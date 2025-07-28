<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%request.setCharacterEncoding("UTF-8");%>


<!DOCTYPE html>
<html lang="ja" class="signup-page">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="styles/u_register.css">
</head>
<body class="signup-page">
<%
    String lang = (String) session.getAttribute("lang");
    if (lang == null) lang = "ja";
%>
<!--CAL logo-->
		<div class="cal-logo">
		  <img src="image/logo-cal.png" alt="CAL Logo">
		</div>
    <!-- Header -->
    <div class="header-controls">
            <div class="btn" id="themeToggle">
			  <div class="btn__indicator">
			    <div class="btn__icon-container">
			      <i class="btn__icon fa-solid"></i>
			    </div>
			  </div>
			</div>
        </div>

    <!-- Main Container -->
    <div class="signup-container">
        <!-- Registration Form -->
        <div class="signup-form-wrapper">
            <div class="signup-panel">
                <div class="panel-content">
                
		            <div class="language-switcher">
						<form action="change-language" method="get">
							<label for="lang" class="lang-label"><%= "ja".equals(lang) ? "🌐 言語選択" : "🌐 Language:" %></label>
								<select name="lang" id="lang" class="lang-select" onchange="this.form.submit()">
								    <option value="ja" <%= "ja".equals(lang) ? "selected" : "" %>>🇯🇵 日本語</option>
									<option value="en" <%= "en".equals(lang) ? "selected" : "" %>>🇺🇸 English</option>
							    </select>
						    <input type="hidden" name="redirect" value="u_register.jsp">
						</form>
					</div>
                    
                    <!-- Panel Header -->
                    <div class="panel-header">
                        <h2 class="panel-title">
                            <%= "ja".equals(lang) ? "会員登録" : "Register" %>
                        </h2>
                    </div>

                    <!-- Registration Form -->
                    <form action="RegisterServlet" method="post" class="signup-form" id="signupForm">
                        
                        <!-- Personal Information Section -->
                        <div class="form-section">
                            <div class="form-group">
                                <div class="input-wrapper">
                                    <ion-icon name="person-outline" class="icons"></ion-icon>
							            <input type="text" 
							                   name="id" 
							                   id="userId" 
							                   placeholder="<%= "ja".equals(lang) ? "ユーザーIDを入力してください" : "Please enter your user ID" %>" 
							                   required 
							                   class="form-input"
							                   maxlength="20"
							                   pattern="[a-zA-Z0-9]+"
							                   title="英数字のみ使用可能です">
							            <button type="button" class="id-check-btn" onclick="checkId()"><%= "ja".equals(lang) ? "確認" : "Check" %></button>
						            <div class="input-focus-line"></div>
                                </div>
                                <div class="input-feedback" id="userIdFeedback"></div>
                            </div>

                            <div class="form-group">
                                <div class="input-wrapper">
                                    <ion-icon name="lock-closed-outline" class="icons"></ion-icon>
                                    <input type="password" 
                                           name="password" 
                                           id="userPassword" 
                                           placeholder="<%= "ja".equals(lang) ? "パスワードを入力してください" : "Please enter your password" %>" 
                                           required 
                                           class="form-input"
                                           minlength="8">
                                    <button type="button" class="password-toggle" onclick="passwordToggles(this)">
									  <ion-icon name="eye-off-outline" class="toggle-icon"></ion-icon>
									</button>
                                    <div class="input-focus-line"></div>
                                </div>
                                <div class="input-feedback" id="passwordFeedback"></div>
                            </div>

                            <div class="form-group">
                                <div class="input-wrapper">
                                    <ion-icon name="finger-print-outline" class="icons"></ion-icon>
                                    <input type="text" 
                                           name="name" 
                                           id="userName" 
                                           placeholder="<%= "ja".equals(lang) ? "名前" : "Your name" %>" 
                                           required 
                                           class="form-input"
                                           maxlength="50">
                                    <div class="input-focus-line"></div>
                                </div>
                                <div class="input-feedback" id="nameFeedback"></div>
                            </div>

                            <div class="form-group">
							    <div class="input-wrapper">
							        <ion-icon name="calendar-outline" class="icons"></ion-icon>
							        <input type="text" 
							               name="birth" 
							               id="userBirth" 
							               placeholder="<%= "ja".equals(lang) ? "生年月日（例：2000/01/01）" : "Date of birth (e.g. 2000/01/01)" %>"
							               maxlength="10" 
							               required 
							               class="form-input"
							               pattern="^(19|20)\d{2}/(0[1-9]|1[0-2])/(0[1-9]|[12]\d|3[01])$"
							               title="<%= "ja".equals(lang) ? "形式：YYYY/MM/DD（例：2000/01/01）" : "Format: YYYY/MM/DD (e.g. 2000/01/01)" %>"
							               oninput="formatBirthDate(this)">
							        <div class="input-focus-line"></div>
							    </div>
							    <div class="input-feedback" id="birthFeedback"></div>
							</div>
                        </div>

                        <!-- Contact Information Section -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <ion-icon name="call-outline" class="icons"></ion-icon>
                                <%= "ja".equals(lang) ? "連絡先情報" : "Contact Information" %>
                            </h3>

                            <div class="form-group">
							    <div class="input-wrapper">
							        <ion-icon name="mail-outline" class="icons"></ion-icon>
							        <input type="email" 
							               name="email" 
							               id="userEmail" 
							               placeholder="<%= "ja".equals(lang) ? "メールアドレス" : "Mail address" %>" 
							               required 
							               class="form-input"
							               maxlength="100">
							        <div class="input-focus-line"></div>
							    </div>
							    <div class="input-feedback" id="emailFeedback"></div>
							    <div class="input-hint"><%= "ja".equals(lang) ? "例：user@example.com の形式で入力してください" : "Format: user@example.com" %></div>
							</div>

                            <div class="form-group">
    <div class="input-wrapper">
        <ion-icon name="phone-portrait-outline" class="icons"></ion-icon>
        <input type="tel" 
               name="phone" 
               id="userPhone" 
               placeholder="<%= "ja".equals(lang) ? "電話番号" : "Phone number" %>" 
               required 
               class="form-input"
               maxlength="13"
               pattern="[0-9\-]{13}">
        <div class="input-focus-line"></div>
    </div>
    <div class="input-feedback" id="phoneFeedback"></div>
</div>

                            <div class="form-group">
                                <div class="input-wrapper">
                                    <ion-icon name="home-outline" class="icons"></ion-icon>
                                    <textarea name="addr" 
                                              id="userAddr" 
                                              placeholder="<%= "ja".equals(lang) ? "住所（郵便番号、都道府県、市区町村、番地・建物名）" : "Address (Postal Code, Prefecture/State, City, Street Address/Building Name)" %>" 
                                              required 
                                              class="form-input form-textarea"
                                              rows="3"></textarea>
                                    <div class="input-focus-line"></div>
                                </div>
                                <div class="input-feedback" id="addrFeedback"></div>
                            </div>
                        </div>

                        <!-- Agreement Section -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <ion-icon name="document-text-outline" class="icons"></ion-icon>
                                <%= "ja".equals(lang) ? "利用規約・設定" : "Terms and Conditions" %>
                            </h3>

                            <div class="form-options">
                                <label class="checkbox-wrapper">
                                    <input type="checkbox" name="newsletter" class="checkbox-input" checked>
                                    <div class="checkbox-custom"></div>
                                    <span class="checkbox-text"><%= "ja".equals(lang) ? "お得な情報をメールで受け取る" : "Receive special offers by email" %></span>
                                </label>
                                
                                <label class="checkbox-wrapper">
                                    <input type="checkbox" name="terms" class="checkbox-input" required>
                                    <div class="checkbox-custom"></div>
                                    <span class="checkbox-text">
                                        <%= "ja".equals(lang) ? "" : "I agree the " %><a href="terms.jsp" target="_blank" class="terms-link"><%= "ja".equals(lang) ? "利用規約" : " Terms " %></a><%= "ja".equals(lang) ? "と" : " and " %>
                                        <a href="privacy.jsp" target="_blank" class="privacy-link"><%= "ja".equals(lang) ? "プライバシーポリシー" : " Privacy Policy" %></a><%= "ja".equals(lang) ? "に同意する" : "." %>
                                    </span>
                                </label>
                            </div>

                            <button type="submit" class="signup-submit-btn" id="signupSubmitBtn">
                                <span class="btn-text"><%= "ja".equals(lang) ? "アカウントを作成" : "Create Account" %></span>
                            </button>
                            
                        
                        </div>
                    </form>
                    <div class="panel-footer">
               			 <a href="login.jsp" class="switch-panel-btn">
						    <button><%= "ja".equals(lang) ? "ログインはこちらへ" : "Go to Login" %></button>
						</a>
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

    <!-- Footer -->
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
		function checkId() {
		    const userId = document.getElementById("userId").value.trim();
		    const feedback = document.getElementById("userIdFeedback");
		
		    // 入力チェック（形式）
		    if (!userId.match(/^[a-zA-Z0-9]{4,20}$/)) {
		        feedback.textContent = "<%= "ja".equals(lang) ? "4〜20文字の英数字で入力してください。" : "Please enter 4 to 20 alphanumeric characters." %>";
		        feedback.style.color = "red";
		        return;
		    }
		
		    fetch('CheckIdServlet?id=' + encodeURIComponent(userId))
		        .then(response => response.text())
		        .then(data => {
		            if (data === 'OK') {
		                feedback.textContent = "<%= "ja".equals(lang) ? "使用可能なIDです。" : "The user ID is available." %>";
		                feedback.style.color = "rgb(0, 208, 0)";
		            } else if (data === 'EXISTS') {
		                feedback.textContent = "<%= "ja".equals(lang) ? "すでに使用されているIDです。他のIDを入力してください。" : "That ID is already taken. Please try another." %>";
		                feedback.style.color = "red";
		            } else {
		                feedback.textContent = "<%= "ja".equals(lang) ? "形式が不正です。" : "Invalid format." %>";
		                feedback.style.color = "red";
		            }
		        })
		        .catch(error => {
		            console.error(error);
		            feedback.textContent = "サーバーエラーが発生しました。";
		            feedback.style.color = "red";
		        });
		}
		
		document.addEventListener('DOMContentLoaded', function() {
		    initializeSignupSystem();
		});

<!--		and-->
function formatBirthDate(input) {
    // 入力値から数字以外を削除
    let raw = input.value.replace(/\D/g, '');

    if (raw.length > 8) raw = raw.slice(0, 8); // 最大8桁まで

    // yyyy/MM/dd形式に変換
    let formatted = raw;
    if (raw.length >= 5) {
        formatted = raw.slice(0, 4) + '/' + raw.slice(4, 6);
        if (raw.length >= 7) {
            formatted += '/' + raw.slice(6, 8);
        }
    }

    input.value = formatted;
}

<!--end-->
document.getElementById('userEmail').addEventListener('blur', function () {
    const email = this.value.trim();
    const feedback = document.getElementById('emailFeedback');
    
    // 簡易なメール形式の正規表現
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    if (email === "") {
        feedback.textContent = ""; // 空欄の時は何も表示しない（HTMLの required が対応）
    } else if (!emailRegex.test(email)) {
        feedback.textContent = "正しいメールアドレス形式で入力してください（例: user@example.com）";
        feedback.style.color = "red";
    } else {
        feedback.textContent = ""; // 正しい場合はエラー消す
    }
});

<!--endees-->
document.getElementById('userPhone').addEventListener('blur', function () {
    let raw = this.value.replace(/-/g, ''); // ハイフン除去
    const feedback = document.getElementById('phoneFeedback');

    if (raw.length === 11 && /^0\d{10}$/.test(raw)) {
        // 080-1234-5678 形式（携帯電話）
        this.value = raw.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        feedback.textContent = "";
    } else if (raw.length === 10 && /^0\d{9}$/.test(raw)) {
        // 市外局番2桁＋市内局番4桁＋番号4桁 など（例: 03-1234-5678）
        this.value = raw.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
        feedback.textContent = "";
    } else {
        feedback.textContent = "電話番号の形式が正しくありません";
        feedback.style.color = "red";
    }
});

</script>
    

    <script src="JavaScript/u_register.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
	<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
	
	

</body>
</html>
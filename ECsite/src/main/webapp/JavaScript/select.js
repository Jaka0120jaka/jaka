/**
 * 
 */
// ========== QUANTITY CONTROL FUNCTIONS ==========

/**
 * Mahsulot miqdorini o'zgartirish funksiyasi
 * @param {HTMLElement} button - Bosilgan tugma elementi
 * @param {number} change - O'zgarish qiymati (+1 yoki -1)
 */
function changeQuantity(button, change) {
    const quantityInput = button.parentNode.querySelector('.qty-input');
    let currentValue = parseInt(quantityInput.value) || 1;
    
    // Yangi qiymatni hisoblash
    let newValue = currentValue + change;
    
    // Minimal qiymat 1 bo'lishi kerak
    if (newValue < 1) {
        newValue = 1;
    }
    
    // Maksimal qiymat 99 bo'lishi kerak
    if (newValue > 99) {
        newValue = 99;
    }
    
    // Qiymatni o'rnatish
    quantityInput.value = newValue;
    
    // Animation effect
    quantityInput.style.transform = 'scale(1.1)';
    setTimeout(() => {
        quantityInput.style.transform = 'scale(1)';
    }, 150);
    
    // Button hover effect
    button.style.transform = 'scale(0.9)';
    setTimeout(() => {
        button.style.transform = 'scale(1)';
    }, 100);
}

// ========== CART FUNCTIONS ==========

/**
 * Mahsulotni korzinaga qo'shish funksiyasi
 * @param {number} idx - Mahsulot indeksi
 * @param {HTMLFormElement} form - Form elementi
 */
function addToCart(idx, form) {
    const quantityInput = form.querySelector('.qty-input');
    const quantity = parseInt(quantityInput.value) || 1;
    const addButton = form.querySelector('.add-to-cart-btn');
    
    // Loading state
    const originalHTML = addButton.innerHTML;
    addButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>追加中...</span>';
    addButton.disabled = true;
    
    // AJAX request to server
    fetch('add-prod-servlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'idx=' + encodeURIComponent(idx) + '&quantity=' + encodeURIComponent(quantity)
    })
    .then(response => response.json())
    .then(data => {
        // Success animation
        addButton.innerHTML = '<i class="fas fa-check"></i> <span>追加完了!</span>';
        addButton.style.background = 'linear-gradient(135deg, #00b894 0%, #00cec9 100%)';
        
        // Update cart count in header
        const cartCountElement = document.getElementById("cart-count");
        if (cartCountElement) {
            cartCountElement.innerText = data.count;
            
            // Animation effect
            cartCountElement.style.transform = 'scale(1.3)';
            cartCountElement.style.background = '#00b894';
            setTimeout(() => {
                cartCountElement.style.transform = 'scale(1)';
                cartCountElement.style.background = '';
            }, 300);
        }
        
        // Show success message
        showNotification(`商品がカートに追加されました (数量: ${quantity})`, 'success');
        
        // Reset button after 2 seconds
        setTimeout(() => {
            addButton.innerHTML = originalHTML;
            addButton.style.background = 'linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%)';
            addButton.disabled = false;
        }, 2000);
        
    })
    .catch(error => {
        console.error('カート追加失敗:', error);
        
        // Error state
        addButton.innerHTML = '<i class="fas fa-exclamation-triangle"></i> <span>エラー</span>';
        addButton.style.background = 'linear-gradient(135deg, #e17055 0%, #d63031 100%)';
        
        // Show error message
        showNotification('カートへの追加に失敗しました。もう一度お試しください。', 'error');
        
        // Reset button after 3 seconds
        setTimeout(() => {
            addButton.innerHTML = originalHTML;
            addButton.style.background = 'linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%)';
            addButton.disabled = false;
        }, 3000);
    });
}

// ========== NOTIFICATION SYSTEM ==========

/**
 * Notification ko'rsatish funksiyasi
 * @param {string} message - Ko'rsatiladigan xabar
 * @param {string} type - Notification turi (success, error, info)
 */
function showNotification(message, type = 'info') {
    // Existing notification o'chirish
    const existingNotification = document.querySelector('.notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    // Yangi notification yaratish
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <i class="fas fa-${getNotificationIcon(type)}"></i>
        <span>${message}</span>
        <button class="notification-close" onclick="this.parentNode.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    // Notification ni sahifaga qo'shish
    document.body.appendChild(notification);
    
    // Animation
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    // Auto remove after 4 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.classList.remove('show');
            setTimeout(() => {
                notification.remove();
            }, 300);
        }
    }, 4000);
}

/**
 * Notification turi bo'yicha icon qaytarish
 * @param {string} type - Notification turi
 * @returns {string} Icon class nomi
 */
function getNotificationIcon(type) {
    switch (type) {
        case 'success': return 'check-circle';
        case 'error': return 'exclamation-circle';
        case 'warning': return 'exclamation-triangle';
        default: return 'info-circle';
    }
}

// ========== SEARCH FUNCTIONALITY ==========

/**
 * Search input uchun real-time search
 */
function initializeSearch() {
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        let searchTimeout;
        
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            
            searchTimeout = setTimeout(() => {
                const keyword = this.value.trim();
                if (keyword.length > 2) {
                    // Real-time search implementation
                    console.log('Searching for:', keyword);
                }
            }, 500);
        });
    }
}

// ========== CATEGORY LINKS ENHANCEMENT ==========

/**
 * Category link hover effects
 */
function initializeCategoryLinks() {
    const categoryLinks = document.querySelectorAll('.category-link');
    
    categoryLinks.forEach(link => {
        link.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px) scale(1.05)';
        });
        
        link.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}

// ========== INITIALIZATION ==========

/**
 * Sahifa yuklanganidan keyin ishga tushiradigan funksiyalar
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize all components
    initializeSearch();
    initializeCategoryLinks();
    
    // Add smooth scrolling for category links
    const categoryLinks = document.querySelectorAll('.category-link');
    categoryLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Add loading effect
            this.style.opacity = '0.7';
            setTimeout(() => {
                this.style.opacity = '1';
            }, 200);
        });
    });
    
    // Enhance product cards with intersection observer for animations
    const productCards = document.querySelectorAll('.product-card');
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const cardObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animationDelay = Math.random() * 0.3 + 's';
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    productCards.forEach(card => {
        cardObserver.observe(card);
    });
});

// ========== QUANTITY INPUT VALIDATION ==========

/**
 * Quantity input validatsiya
 */
document.addEventListener('DOMContentLoaded', function() {
    const quantityInputs = document.querySelectorAll('.qty-input');
    
    quantityInputs.forEach(input => {
        input.addEventListener('input', function() {
            let value = parseInt(this.value);
            
            if (isNaN(value) || value < 1) {
                this.value = 1;
            } else if (value > 99) {
                this.value = 99;
            }
        });
        
        input.addEventListener('blur', function() {
            if (this.value === '' || parseInt(this.value) < 1) {
                this.value = 1;
            }
        });
    });
});
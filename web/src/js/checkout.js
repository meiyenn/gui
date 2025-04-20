/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
    // Handle the delivery option selection
    document.querySelectorAll('.delivery-option').forEach(option => {
        option.addEventListener('click', function() {
            // Update the visual selection
            document.querySelectorAll('.delivery-option').forEach(el => el.classList.remove('selected'));
            this.classList.add('selected');
            
            // Check the radio button
            this.querySelector('input').checked = true;
            
            // Update hidden fields in both forms to maintain state
            const deliveryValue = this.querySelector('input').value;
            document.querySelectorAll('input[name="deliveryMethod"]').forEach(input => {
                input.value = deliveryValue;
            });
            
            // Toggle shipping address fields based on delivery method
            const shippingAddressSection = document.querySelector('.shipping-address');
            if (deliveryValue === 'delivery') {
                shippingAddressSection.style.display = 'block';
                // Make address fields required when delivery is selected
                document.getElementById('street').required = true;
                document.getElementById('city').required = true;
                document.getElementById('postalCode').required = true;
                document.getElementById('state').required = true;
            } else {
                shippingAddressSection.style.display = 'none';
                // Make address fields not required when pickup is selected
                document.getElementById('street').required = false;
                document.getElementById('city').required = false;
                document.getElementById('postalCode').required = false;
                document.getElementById('state').required = false;
            }
        });
    });
    
    // Payment method selection and display appropriate options
    const paymentSelect = document.getElementById('paymentMethod');
    const cardContainer = document.getElementById('cardContainer');
    const bankContainer = document.getElementById('bankContainer');
    
    paymentSelect.addEventListener('change', function() {
        // Hide all payment option containers first
        cardContainer.style.display = 'none';
        bankContainer.style.display = 'none';
        
        // Show the relevant container based on selection
        if (this.value === 'debit_card') {
            cardContainer.style.display = 'block';
        } else if (this.value === 'online_banking') {
            bankContainer.style.display = 'block';
        }
    });
    
    // Card number formatting
    const cardNumberInput = document.getElementById('cardNumber');
    cardNumberInput.addEventListener('input', function(e) {
        // Remove all non-digit characters
        let value = this.value.replace(/\D/g, '');
        
        // Add spaces after every 4 digits
        let formattedValue = '';
        for (let i = 0; i < value.length; i++) {
            if (i > 0 && i % 4 === 0) {
                formattedValue += ' ';
            }
            formattedValue += value[i];
        }
        
        // Update the input value
        this.value = formattedValue;
    });
    
    // Expiry date formatting
    const expiryInput = document.getElementById('expiry');
    expiryInput.addEventListener('input', function(e) {
        // Remove all non-digit characters
        let value = this.value.replace(/\D/g, '');
        
        // Format as MM/YY
        if (value.length > 2) {
            this.value = value.substring(0, 2) + '/' + value.substring(2, 4);
        } else {
            this.value = value;
        }
    });
    
    // Form validation
    const form = document.getElementById('checkoutForm');
    const payButton = document.getElementById('payButton');
    
    // Get all error message elements
    const cardNumberError = document.getElementById('cardNumberError');
    const expiryError = document.getElementById('expiryError');
    const cvvError = document.getElementById('cvvError');
    const cardNameError = document.getElementById('cardNameError');
    
    // Validation functions
    function validateCardNumber(cardNumber) {
        // Remove spaces and check if it contains only digits
        const cleaned = cardNumber.replace(/\s/g, '');
        
        // Check for valid card length (13-19 digits)
        if (!/^\d{13,19}$/.test(cleaned)) {
            return false;
        }
        
        // Luhn algorithm (mod 10) for card number validation
        let sum = 0;
        let shouldDouble = false;
        
        // Loop through values starting from the rightmost digit
        for (let i = cleaned.length - 1; i >= 0; i--) {
            let digit = parseInt(cleaned.charAt(i));
            
            if (shouldDouble) {
                digit *= 2;
                if (digit > 9) {
                    digit -= 9;
                }
            }
            
            sum += digit;
            shouldDouble = !shouldDouble;
        }
        
        return (sum % 10) === 0;
    }
    
    function validateExpiry(expiry) {
        // Check format
        if (!/^\d{2}\/\d{2}$/.test(expiry)) {
            return false;
        }
        
        const [month, year] = expiry.split('/');
        const currentDate = new Date();
        const currentYear = currentDate.getFullYear() % 100; // Get last 2 digits
        const currentMonth = currentDate.getMonth() + 1; // Months are 0-based
        
        // Check if month is valid (1-12)
        if (parseInt(month) < 1 || parseInt(month) > 12) {
            return false;
        }
        
        // Check if card is not expired
        if (parseInt(year) < currentYear || 
            (parseInt(year) === currentYear && parseInt(month) < currentMonth)) {
            return false;
        }
        
        return true;
    }
    
    function validateCVV(cvv) {
        // CVV is generally 3-4 digits
        return /^\d{3,4}$/.test(cvv);
    }
    
    // Live validation for card fields
    cardNumberInput.addEventListener('blur', function() {
        if (paymentSelect.value === 'debit_card') {
            const isValid = validateCardNumber(this.value);
            this.classList.toggle('is-invalid', !isValid);
            this.classList.toggle('is-valid', isValid);
            cardNumberError.style.display = isValid ? 'none' : 'block';
        }
    });
    
    expiryInput.addEventListener('blur', function() {
        if (paymentSelect.value === 'debit_card') {
            const isValid = validateExpiry(this.value);
            this.classList.toggle('is-invalid', !isValid);
            this.classList.toggle('is-valid', isValid);
            expiryError.style.display = isValid ? 'none' : 'block';
        }
    });
    
    const cvvInput = document.getElementById('cvv');
    cvvInput.addEventListener('blur', function() {
        if (paymentSelect.value === 'debit_card') {
            const isValid = validateCVV(this.value);
            this.classList.toggle('is-invalid', !isValid);
            this.classList.toggle('is-valid', isValid);
            cvvError.style.display = isValid ? 'none' : 'block';
        }
    });
    
    const cardNameInput = document.getElementById('cardName');
    cardNameInput.addEventListener('blur', function() {
        if (paymentSelect.value === 'debit_card') {
            const isValid = this.value.trim().length > 0;
            this.classList.toggle('is-invalid', !isValid);
            this.classList.toggle('is-valid', isValid);
            cardNameError.style.display = isValid ? 'none' : 'block';
        }
    });
    
    // Form submission validation
    form.addEventListener('submit', function(e) {
        // Regular form validation
        const fullName = document.getElementById('fullName');
        const email = document.getElementById('email');
        const phone = document.getElementById('phone');
        
        // Address fields
        const street = document.getElementById('street');
        const city = document.getElementById('city');
        const postalCode = document.getElementById('postalCode');
        const state = document.getElementById('state');
        
        let isValid = true;
        
        // Basic field validation
        if (fullName.value.trim() === '') {
            isValid = false;
            fullName.classList.add('is-invalid');
        }
        
        if (email.value.trim() === '' || !email.value.includes('@')) {
            isValid = false;
            email.classList.add('is-invalid');
        }
        
        if (phone.value.trim() === '') {
            isValid = false;
            phone.classList.add('is-invalid');
        }
        
        // Address validation - only required for delivery option
        if (document.getElementById('delivery').checked) {
            if (street.value.trim() === '') {
                isValid = false;
                street.classList.add('is-invalid');
            }
            
            if (city.value.trim() === '') {
                isValid = false;
                city.classList.add('is-invalid');
            }
            
            if (postalCode.value.trim() === '') {
                isValid = false;
                postalCode.classList.add('is-invalid');
            }
            
            if (state.value === '') {
                isValid = false;
                state.classList.add('is-invalid');
            }
        }
        
        // Credit card validation if payment method is debit/credit card
        if (paymentSelect.value === 'debit_card') {
            // Check card number
            if (!validateCardNumber(cardNumberInput.value)) {
                isValid = false;
                cardNumberInput.classList.add('is-invalid');
                cardNumberError.style.display = 'block';
            }
            
            // Check expiry
            if (!validateExpiry(expiryInput.value)) {
                isValid = false;
                expiryInput.classList.add('is-invalid');
                expiryError.style.display = 'block';
            }
            
            // Check CVV
            if (!validateCVV(cvvInput.value)) {
                isValid = false;
                cvvInput.classList.add('is-invalid');
                cvvError.style.display = 'block';
            }
            
            // Check card name
            if (cardNameInput.value.trim() === '') {
                isValid = false;
                cardNameInput.classList.add('is-invalid');
                cardNameError.style.display = 'block';
            }
        }
        
        // Bank selection validation if payment method is online banking
        if (paymentSelect.value === 'online_banking') {
            const bankSelection = document.getElementById('bankSelection');
            const bankSelectionError = document.getElementById('bankSelectionError');
            
            if (bankSelection.value === '') {
                isValid = false;
                bankSelection.classList.add('is-invalid');
                bankSelectionError.style.display = 'block';
            }
        }
        
        if (!isValid) {
            e.preventDefault();
        }
    });
    
function showConfirmation() {
    document.getElementById("confirmationOverlay").style.display = "flex";
}

function hideConfirmation() {
    document.getElementById("confirmationOverlay").style.display = "none";
}

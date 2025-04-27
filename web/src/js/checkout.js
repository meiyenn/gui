// Document ready function to ensure DOM is fully loaded
document.addEventListener('DOMContentLoaded', function() {
    initDeliveryOptions();
    initPaymentMethodHandling();
    initCardFormatting();
    initFormValidation();
});


function initDeliveryOptions() {
    document.querySelectorAll('.delivery-option').forEach(option => {
        option.addEventListener('click', function () {
            // Update visual selection
            document.querySelectorAll('.delivery-option').forEach(el => el.classList.remove('selected'));
            this.classList.add('selected');

            // Set the radio button checked
            const input = this.querySelector('input[type="radio"]');
            input.checked = true;

            // Directly use this input's value to control address section
            toggleShippingAddressFields(input.value);
        });
    });
}



function toggleShippingAddressFields(deliveryValue) {
    const shippingAddressSection = document.querySelector('.shipping-address');
    const addressFields = ['street', 'city', 'postalCode', 'state'];
    
    if (deliveryValue === 'delivery') {
        shippingAddressSection.style.display = 'block';
        // Make address fields required
        addressFields.forEach(field => {
            document.getElementById(field).required = true;
        });
    } else {
        shippingAddressSection.style.display = 'none';
        // Make address fields not required
        addressFields.forEach(field => {
            document.getElementById(field).required = false;
        });
    }
}


function initPaymentMethodHandling() {
    const paymentSelect = document.getElementById('paymentMethod');
    const paymentContainers = {
        'debit_card': document.getElementById('cardContainer'),
        'online_banking': document.getElementById('bankContainer')
    };
    
    paymentSelect.addEventListener('change', function() {
        // Hide all payment containers first
        Object.values(paymentContainers).forEach(container => {
            container.style.display = 'none';
        });
        
        // Show the relevant container based on selection
        if (paymentContainers[this.value]) {
            paymentContainers[this.value].style.display = 'block';
        }
    });
}


function initCardFormatting() {
    // Card number formatting
    const cardNumberInput = document.getElementById('cardNumber');
    cardNumberInput.addEventListener('input', function() {
        // Remove non-digit characters
        let value = this.value.replace(/\D/g, '');
        
        // Format with spaces after every 4 digits
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
    
    // Expiry date formatting (MM/YY)
    const expiryInput = document.getElementById('expiry');
    expiryInput.addEventListener('input', function() {
        // Remove non-digit characters
        let value = this.value.replace(/\D/g, '');
        
        // Format as MM/YY
        if (value.length > 2) {
            this.value = value.substring(0, 2) + '/' + value.substring(2, 4);
        } else {
            this.value = value;
        }
    });
}


function initFormValidation() {
    const form = document.getElementById('checkoutForm');
    
    // Get all input elements and their error message elements
    const validationConfig = {
        'cardNumber': {
            errorElement: document.getElementById('cardNumberError'),
            validator: validateCardNumber
        },
        'expiry': {
            errorElement: document.getElementById('expiryError'),
            validator: validateExpiry
        },
        'cvv': {
            errorElement: document.getElementById('cvvError'),
            validator: validateCVV
        },
        'cardName': {
            errorElement: document.getElementById('cardNameError'),
            validator: (value) => value.trim().length > 0
        }
    };
    
    // Add blur event listeners for live validation
    Object.keys(validationConfig).forEach(fieldId => {
        const input = document.getElementById(fieldId);
        const config = validationConfig[fieldId];
        
        input.addEventListener('blur', function() {
            const paymentSelect = document.getElementById('paymentMethod');
            
            // Only validate if this payment method is selected
            if (paymentSelect.value === 'debit_card') {
                const isValid = config.validator(this.value);
                updateValidationUI(this, config.errorElement, isValid);
            }
        });
    });
    
    // Form submission validation
    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
        }
    });
}


function updateValidationUI(element, errorElement, isValid) {
    element.classList.toggle('is-invalid', !isValid);
    element.classList.toggle('is-valid', isValid);
    if (errorElement) {
        errorElement.style.display = isValid ? 'none' : 'block';
    }
}


function validateForm() {
    const paymentSelect = document.getElementById('paymentMethod');
    let isValid = true;
    
    // Basic personal info validation
    const basicFields = ['fullName', 'email', 'phone'];
    basicFields.forEach(field => {
        const element = document.getElementById(field);
        let fieldValid = element.value.trim() !== '';
        
        // Additional validation for email
        if (field === 'email' && !element.value.includes('@')) {
            fieldValid = false;
        }
        
        if (!fieldValid) {
            isValid = false;
            element.classList.add('is-invalid');
        }
    });
    
    // Address validation - only if delivery is selected
    if (document.getElementById('delivery').checked) {
        const addressFields = ['street', 'city', 'postalCode', 'state'];
        addressFields.forEach(field => {
            const element = document.getElementById(field);
            const fieldValid = element.value.trim() !== '' && 
                              (field !== 'state' || element.value !== '');
            
            if (!fieldValid) {
                isValid = false;
                element.classList.add('is-invalid');
            }
        });
    }
    
    // Payment method validation
    if (paymentSelect.value === 'debit_card') {
        // Card validation
        const cardFields = {
            'cardNumber': validateCardNumber,
            'expiry': validateExpiry,
            'cvv': validateCVV,
            'cardName': (value) => value.trim().length > 0
        };
        
        Object.entries(cardFields).forEach(([field, validator]) => {
            const element = document.getElementById(field);
            const errorElement = document.getElementById(`${field}Error`);
            const fieldValid = validator(element.value);
            
            if (!fieldValid) {
                isValid = false;
                updateValidationUI(element, errorElement, false);
            }
        });
    } else if (paymentSelect.value === 'online_banking') {
        // Bank selection validation
        const bankSelection = document.getElementById('bankSelection');
        const bankSelectionError = document.getElementById('bankSelectionError');
        
        if (bankSelection.value === '') {
            isValid = false;
            updateValidationUI(bankSelection, bankSelectionError, false);
        }
    }
    
    return isValid;
}


function validateCardNumber(cardNumber) {
    // Remove spaces and check if it contains only digits
    const cleaned = cardNumber.replace(/\s/g, '');
    
    // Check for valid card length (13-19 digits)
    if (!/^\d{13,19}$/.test(cleaned)) {
        return false;
    }
    
    // Luhn algorithm (mod 10) implementation
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
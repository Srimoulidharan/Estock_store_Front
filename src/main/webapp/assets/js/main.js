// assets/js/main.js

document.addEventListener('DOMContentLoaded', function() {
    // Sample cart functionality
    const addToCartButtons = document.querySelectorAll('.btn-success');
    
    addToCartButtons.forEach(button => {
        button.addEventListener('click', function() {
            alert('Item added to cart!');
            // Here you could store the cart items in local storage
        });
    });
});

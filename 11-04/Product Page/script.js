document.addEventListener('click', function(e) {
    if (e.target && e.target.classList.contains('btn-add-cart')) {
        const btn = e.target;

        btn.innerHTML = "✓ Added";
        btn.classList.replace('btn-primary', 'btn-success');
        btn.disabled = true;

        const toastElement = document.getElementById('cartToast');
        if (toastElement) {
            const toast = new bootstrap.Toast(toastElement);
            toast.show();
        } else {
            console.error("Could not find the element with id 'cartToast'");
        }

        setTimeout(() => {
            btn.innerHTML = "Add to Cart";
            btn.classList.replace('btn-success', 'btn-primary');
            btn.disabled = false;
        }, 2000);
    }
});
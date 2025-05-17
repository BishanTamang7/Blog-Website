// Admin Dashboard JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize sidebar active state
    initSidebar();

    // Initialize modals
    initModals();

    // Initialize alerts dismissal
    initAlerts();

    // Initialize any forms
    initForms();
});

// Sidebar initialization
function initSidebar() {
    const currentPath = window.location.pathname;
    const menuItems = document.querySelectorAll('.menu-item');

    menuItems.forEach(item => {
        const href = item.getAttribute('href');
        // Check if the current path contains the href (more robust check)
        if (href && currentPath.includes(href.split('/').pop())) {
            item.classList.add('active');
        }

        // Prevent default action on double-click to avoid navigation issues
        item.addEventListener('dblclick', function(e) {
            e.preventDefault();
            // If we're already on this page, don't try to navigate again
            if (currentPath.includes(href.split('/').pop())) {
                return false;
            }
        });

        // Add click event for mobile view
        item.addEventListener('click', function(e) {
            // If we're already on this page, prevent navigation
            if (href && currentPath.includes(href.split('/').pop())) {
                e.preventDefault();
                return false;
            }
            menuItems.forEach(i => i.classList.remove('active'));
            this.classList.add('active');
        });
    });
}

// Modal functionality
function initModals() {
    // Open modal buttons
    const modalTriggers = document.querySelectorAll('[data-modal]');
    modalTriggers.forEach(trigger => {
        trigger.addEventListener('click', function(e) {
            e.preventDefault();
            const modalId = this.getAttribute('data-modal');
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.add('active');
            }
        });
    });

    // Close modal buttons
    const closeBtns = document.querySelectorAll('.modal-close, .modal-cancel');
    closeBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const modal = this.closest('.modal-overlay');
            if (modal) {
                modal.classList.remove('active');
            }
        });
    });

    // Close modal when clicking outside
    const modals = document.querySelectorAll('.modal-overlay');
    modals.forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === this) {
                this.classList.remove('active');
            }
        });
    });
}

// Alert dismissal
function initAlerts() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        // Add close button if it doesn't exist
        if (!alert.querySelector('.alert-close')) {
            const closeBtn = document.createElement('button');
            closeBtn.className = 'alert-close';
            closeBtn.innerHTML = '&times;';
            closeBtn.style.float = 'right';
            closeBtn.style.background = 'none';
            closeBtn.style.border = 'none';
            closeBtn.style.cursor = 'pointer';
            closeBtn.style.fontSize = '1.2rem';
            alert.appendChild(closeBtn);

            closeBtn.addEventListener('click', function() {
                alert.style.display = 'none';
            });
        }
    });
}

// Form handling
function initForms() {
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            // For demo purposes, prevent actual submission
            if (form.classList.contains('demo-form')) {
                e.preventDefault();
                showNotification('Form submitted successfully!', 'success');

                // Close modal if form is in a modal
                const modal = form.closest('.modal-overlay');
                if (modal) {
                    setTimeout(() => {
                        modal.classList.remove('active');
                    }, 1000);
                }
            }
        });
    });
}

// Show notification
function showNotification(message, type = 'info') {
    // Create notification element if it doesn't exist
    let notification = document.querySelector('.notification');
    if (!notification) {
        notification = document.createElement('div');
        notification.className = 'notification';
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.padding = '15px 20px';
        notification.style.borderRadius = '4px';
        notification.style.color = 'white';
        notification.style.zIndex = '1000';
        notification.style.boxShadow = '0 4px 8px rgba(0,0,0,0.1)';
        notification.style.transition = 'all 0.3s ease';
        notification.style.opacity = '0';
        document.body.appendChild(notification);
    }

    // Set notification type
    switch(type) {
        case 'success':
            notification.style.backgroundColor = 'var(--success-color)';
            break;
        case 'warning':
            notification.style.backgroundColor = 'var(--warning-color)';
            break;
        case 'error':
            notification.style.backgroundColor = 'var(--danger-color)';
            break;
        default:
            notification.style.backgroundColor = 'var(--primary-color)';
    }

    // Set message and show notification
    notification.textContent = message;
    notification.style.opacity = '1';

    // Hide notification after 3 seconds
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

// Data table functionality
function initDataTable(tableId) {
    const table = document.getElementById(tableId);
    if (!table) return;

    // Add search functionality
    const searchInput = document.querySelector(`#${tableId}-search`);
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = table.querySelectorAll('tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        });
    }

    // Add sorting functionality
    const headers = table.querySelectorAll('th[data-sort]');
    headers.forEach(header => {
        header.style.cursor = 'pointer';
        header.addEventListener('click', function() {
            const column = this.cellIndex;
            const sortDir = this.getAttribute('data-sort-dir') || 'asc';
            const rows = Array.from(table.querySelectorAll('tbody tr'));

            rows.sort((a, b) => {
                const aValue = a.cells[column].textContent.trim();
                const bValue = b.cells[column].textContent.trim();

                if (sortDir === 'asc') {
                    return aValue.localeCompare(bValue);
                } else {
                    return bValue.localeCompare(aValue);
                }
            });

            // Update sort direction
            this.setAttribute('data-sort-dir', sortDir === 'asc' ? 'desc' : 'asc');

            // Update table with sorted rows
            const tbody = table.querySelector('tbody');
            rows.forEach(row => tbody.appendChild(row));
        });
    });
}

// User management functions
function createUser(userData) {
    // In a real application, this would make an API call
    console.log('Creating user:', userData);
    showNotification('User created successfully!', 'success');

    // For demo, add to table
    const userTable = document.getElementById('users-table');
    if (userTable) {
        const tbody = userTable.querySelector('tbody');
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${userData.username}</td>
            <td>${userData.email}</td>
            <td><span class="badge badge-${userData.role === 'admin' ? 'primary' : 'success'}">${userData.role}</span></td>
            <td>${new Date().toLocaleDateString()}</td>
            <td>
                <div class="action-buttons">
                    <button class="btn btn-sm btn-primary">Edit</button>
                    <button class="btn btn-sm btn-danger">Delete</button>
                </div>
            </td>
        `;
        tbody.appendChild(row);
    }
}

function deleteUser(userId) {
    // In a real application, this would make an API call
    console.log('Deleting user:', userId);
    showNotification('User deleted successfully!', 'success');
}

// Post management functions
function deletePost(postId) {
    // In a real application, this would make an API call
    console.log('Deleting post:', postId);
    showNotification('Post deleted successfully!', 'success');
}

// Category management functions
function createCategory(categoryData) {
    // In a real application, this would make an API call
    console.log('Creating category:', categoryData);
    showNotification('Category created successfully!', 'success');

    // For demo, add to table
    const categoryTable = document.getElementById('categories-table');
    if (categoryTable) {
        const tbody = categoryTable.querySelector('tbody');
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${categoryData.name}</td>
            <td>${categoryData.description}</td>
            <td>0</td>
            <td>
                <div class="action-buttons">
                    <button class="btn btn-sm btn-primary">Edit</button>
                    <button class="btn btn-sm btn-danger">Delete</button>
                </div>
            </td>
        `;
        tbody.appendChild(row);
    }
}

function deleteCategory(categoryId) {
    // In a real application, this would make an API call
    console.log('Deleting category:', categoryId);
    showNotification('Category deleted successfully!', 'success');
}

// Chart initialization (if using charts)
function initCharts() {
    // This is a placeholder for chart initialization
    // In a real application, you would use a charting library
    console.log('Charts initialized');
}

# Use official PHP with Apache
FROM php:8.1-apache

# Install mysqli extension and other necessary PHP extensions
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Install additional useful extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite for pretty URLs if needed
RUN a2enmod rewrite

# Copy application files to Apache document root
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create uploads directory if it doesn't exist
RUN mkdir -p /var/www/html/uploads/profiles \
    && chown -R www-data:www-data /var/www/html/uploads \
    && chmod -R 755 /var/www/html/uploads

# Expose port 80
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]

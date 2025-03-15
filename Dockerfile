# Use the official Python image
FROM python:3.11

# Set the working directory inside the container
WORKDIR /shoppinglyx

# Copy the project files into the container
COPY . /shoppinglyx

# Install dependencies (including Gunicorn)
RUN pip install --no-cache-dir -r requirements.txt gunicorn


# Copy .env file into the container
COPY .env /shoppinglyx/.env

# Expose port 8000
EXPOSE 8000

# Run migrations and collect static files
RUN python manage.py migrate || true  # Prevent build failure if migration fails
# Copy media files into the container
# Create directories for static and media files
RUN mkdir -p /shoppinglyx/staticfiles /shoppinglyx/media

# Copy existing media files from the project into the container
COPY media/ /shoppinglyx/media/

RUN python manage.py collectstatic --noinput || true  # Ignore errors


# Start the application with Gunicorn
CMD ["gunicorn", "shoppinglyx.wsgi:application", "--bind", "0.0.0.0:8000"]

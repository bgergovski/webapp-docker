# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file into the container
COPY src/requirements.txt requirements.txt

# Install any dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY src .

# Make port 80 available to the world outside this container
EXPOSE 80

# Install curl which is required for the healthcheck
RUN apt update && apt install curl -y

# Define the command to run the application
CMD ["python", "app.py"]
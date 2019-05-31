# Use an official Python runtime as a parent image
FROM python:3.7.3

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages 
RUN pip3 install --trusted-host pypi.org Flask
RUN pip3 install --trusted-host pypi.org Redis

# Make port 80 available to the world outside this container
EXPOSE 80

# Run app.py when the container launches
CMD ["python3", "app.py"]

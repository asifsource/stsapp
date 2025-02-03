# SimpleTimeService - Dockerized Microservice

## Overview

The **SimpleTimeService (stsapp)** is a simple microservice that returns the current timestamp and the IP address of the visitor in a JSON format. It is a web server application that can be built and run using Docker. This service is designed to run as a non-root user inside the Docker container.

## Project Structure

- **app/**: Contains the source code for the `SimpleTimeService` application.
- **Dockerfile**: The configuration file for building the Docker image.
- **requirements.txt**: Lists any dependencies needed for the application.
## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- [Docker](https://www.docker.com/get-started) (version 19.03 or later)
- Access to the terminal or command prompt

## Project Structure

- **app/**: Contains the main application files (`stsapp.py`, `requirements.txt`).
- **Dockerfile**: The configuration file for building the Docker image.

## How to Build the Docker Image

To build the Docker image for this application, follow these steps:

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/asifsource/stsapp.git
   cd stsapp
   
2. Build the Docker image using the following command:

   ```bash
   docker build -t stsapp:latest .
   This will create a Docker image named stsapp with the latest tag.

3. Run the Docker container using the following command:

   ```bash
   docker run -p 8000:8000 asifsource/stsapp
   This will map port 8000 of the container to port 8000 on your local machine.

4. You can access the application by navigating to:

   ```arduino
   http://localhost:8000
   This will trigger the application to return the current timestamp and the IP address of the visitor in a JSON format.

## Troubleshooting

1. Port Already in Use:
      If port 8000 is already in use by another process, change the port mapping in the docker run command.
      For example:
   ```bash
   docker run -p 8080:8000 asifsource/stsapp

2. Docker Daemon Not Running:
      Ensure Docker is running on your machine. If Docker is not running, start it and retry the above steps.

3. Docker Build Fails:
      If the build fails, make sure that your Dockerfile and application dependencies (listed in requirements.txt) are correctly configured.
 

# stsapp - Dockerized Application

This repository contains a Dockerized application, `stsapp`. The application is structured with an `app` directory and a Dockerfile that allows you to build and run the application inside a container.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- [Docker](https://www.docker.com/get-started) (version 19.03 or later)
- Access to the terminal or command prompt

## Project Structure

- **app/**: Contains the main application files stsapp.py & requirements.txt.
- **Dockerfile**: The configuration file for building the Docker image.

## How to Build the Docker Image

To build the Docker image for this application, follow these steps:

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/asifsource/stsapp.git
   cd stsapp

   Build the Docker image using the following command:
     "docker build -t stsapp:latest ."
  This will create a Docker image named stsapp with the latest tag.

  Use the following command to start the container:
    "docker run -p 8000:8000 asifsource/stsapp"
  This will map port 8000 of the container to port 8000 on your local machine.

  You can access the application by navigating to: 
    "http://localhost:8000"

## Troubleshooting

    1. Port Already in Use: If port 8000 is already in use by another process, change the port mapping in the docker run command.
    For example:
    "docker run -p 8080:8000 asifsource/stsapp"
    
    2. Docker Daemon Not Running: Make sure Docker is running on your machine.
    If Docker is not running, start it and retry the above steps.



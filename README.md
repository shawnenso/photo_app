# AI Photo Album System

This project is a self-hosted web and mobile-friendly application that allows photographers to upload event photos and automatically distribute them to clients using AI-powered facial recognition.

The system uses Amazon Rekognition to detect faces in uploaded images and automatically group photos by unique individuals. Each detected face becomes its own album. Clients can log in using a selfie, and the system will match their face to the correct album, allowing them to instantly access and download their photos.

## Key Features

* Photographer photo uploads
* Automatic face detection using Amazon Rekognition
* Automatic grouping of photos by unique faces
* Selfie-based client login and face matching
* Client photo albums with download capability
* Admin dashboard for managing users, photos, and albums
* Modern responsive UI for web, mobile, and desktop

## Tech Stack

**Backend**

* Python
* Django
* Django REST Framework
* PostgreSQL

**Frontend**

* Flutter (Web, Mobile, Desktop)

**AI / Face Recognition**

* Amazon Rekognition

**Storage**

* Amazon S3

**Authentication**

* JWT Authentication
* Role-based access control (Admin / Photographer / Client)

## Deployment

The system is designed to be fully self-hosted and deployable using:

* Docker
* Linux servers
* AWS or DigitalOcean

## Status

🚧 This project is currently under active development as part of my learning journey in full-stack development and cloud architecture.

Contributions, suggestions, and feedback are welcome.

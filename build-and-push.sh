#!/bin/bash

# Docker Hub Build Script for GLKVM Cloud
# =======================================
# This script builds the GLKVM Cloud application and pushes it to Docker Hub

set -e  # Exit on error

# Configuration
DOCKER_USERNAME="${DOCKER_USERNAME:-your-dockerhub-username}"
IMAGE_NAME="${IMAGE_NAME:-glkvm-cloud}"
TAG="${TAG:-latest}"

FULL_IMAGE="${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "========================================="
echo "Building GLKVM Cloud Docker Image"
echo "========================================="
echo "Image: ${FULL_IMAGE}"
echo ""

# Step 1: Build the frontend (UI)
echo "Step 1/4: Building frontend..."
cd ui
npm install
npm run build
cd ..

# Step 2: Build the Go binary
echo ""
echo "Step 2/4: Syncing Go dependencies..."
go mod tidy

echo ""
echo "Step 3/4: Building Go binary..."
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o rttys

# Step 4: Build Docker image
echo ""
echo "Step 4/5: Building Docker image..."
docker build -t "${FULL_IMAGE}" .

# Step 5: Push to Docker Hub
echo ""
echo "Step 5/5: Pushing to Docker Hub..."
echo "Make sure you are logged in to Docker Hub (run: docker login)"
read -p "Do you want to push to Docker Hub now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    docker push "${FULL_IMAGE}"
    echo ""
    echo "✓ Successfully pushed ${FULL_IMAGE}"
else
    echo "Skipped pushing to Docker Hub"
    echo "To push manually later, run:"
    echo "  docker push ${FULL_IMAGE}"
fi

echo ""
echo "========================================="
echo "Build Complete!"
echo "========================================="
echo "Image: ${FULL_IMAGE}"
echo ""
echo "To use this image:"
echo "  docker pull ${FULL_IMAGE}"
echo "  docker run -p 443:443 -p 10443:10443 -p 5912:5912 ${FULL_IMAGE}"

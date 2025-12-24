#!/bin/bash

# Docker-based Build Script for GLKVM Cloud
# ==========================================
# This script builds everything inside Docker (no local Go/npm needed!)

set -e  # Exit on error

# Configuration
DOCKER_USERNAME="${DOCKER_USERNAME:-your-dockerhub-username}"
IMAGE_NAME="${IMAGE_NAME:-glkvm-cloud}"
TAG="${TAG:-latest}"

FULL_IMAGE="${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "========================================="
echo "Building GLKVM Cloud with Docker"
echo "========================================="
echo "Image: ${FULL_IMAGE}"
echo ""
echo "This will build everything inside Docker containers."
echo "No local Go or npm installation needed!"
echo ""

# Build using multi-stage Dockerfile
echo "Building Docker image (this may take a few minutes)..."
docker build -f Dockerfile.builder -t "${FULL_IMAGE}" .

echo ""
echo "✓ Build complete!"
echo ""

# Push to Docker Hub
echo "Do you want to push to Docker Hub now? (y/n) "
read -r -n 1 REPLY
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Pushing to Docker Hub..."
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

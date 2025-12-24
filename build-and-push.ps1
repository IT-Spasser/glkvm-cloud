# Docker Hub Build Script for GLKVM Cloud (PowerShell)
# ======================================================
# This script builds the GLKVM Cloud application and pushes it to Docker Hub

param(
    [string]$DockerUsername = "your-dockerhub-username",
    [string]$ImageName = "glkvm-cloud",
    [string]$Tag = "latest"
)

$ErrorActionPreference = "Stop"

$FullImage = "${DockerUsername}/${ImageName}:${Tag}"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Building GLKVM Cloud Docker Image" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Image: $FullImage" -ForegroundColor Yellow
Write-Host ""

# Step 1: Build the frontend (UI)
Write-Host "Step 1/4: Building frontend..." -ForegroundColor Green
Push-Location ui
npm install
npm run build
Pop-Location

# Step 2: Build the Go binary
Write-Host ""
Write-Host "Step 2/4: Building Go binary..." -ForegroundColor Green
$env:CGO_ENABLED = "0"
$env:GOOS = "linux"
$env:GOARCH = "amd64"
go build -ldflags "-s -w" -o rttys

# Step 3: Build Docker image
Write-Host ""
Write-Host "Step 3/4: Building Docker image..." -ForegroundColor Green
docker build -t "$FullImage" .

# Step 4: Push to Docker Hub
Write-Host ""
Write-Host "Step 4/4: Pushing to Docker Hub..." -ForegroundColor Green
Write-Host "Make sure you are logged in to Docker Hub (run: docker login)" -ForegroundColor Yellow

$response = Read-Host "Do you want to push to Docker Hub now? (y/n)"
if ($response -eq "y" -or $response -eq "Y") {
    docker push "$FullImage"
    Write-Host ""
    Write-Host "✓ Successfully pushed $FullImage" -ForegroundColor Green
} else {
    Write-Host "Skipped pushing to Docker Hub" -ForegroundColor Yellow
    Write-Host "To push manually later, run:" -ForegroundColor Yellow
    Write-Host "  docker push $FullImage" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Build Complete!" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Image: $FullImage" -ForegroundColor Yellow
Write-Host ""
Write-Host "To use this image:" -ForegroundColor White
Write-Host "  docker pull $FullImage" -ForegroundColor White
Write-Host "  docker run -p 443:443 -p 10443:10443 -p 5912:5912 $FullImage" -ForegroundColor White

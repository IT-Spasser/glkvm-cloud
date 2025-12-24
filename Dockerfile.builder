# Multi-stage Dockerfile - bygger alt i Docker
FROM node:20-alpine AS ui-builder
WORKDIR /build/ui
COPY ui/package*.json ./
RUN npm install
COPY ui/ ./
RUN npm run build

FROM golang:1.24-alpine AS go-builder
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
COPY --from=ui-builder /build/ui/dist ./ui/dist
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o rttys

FROM alpine:latest
WORKDIR /home
COPY --from=go-builder /build/rttys /usr/bin/rttys
ENTRYPOINT ["/usr/bin/rttys"]

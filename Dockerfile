FROM node:16.19.0 AS builder

# Set working directory
WORKDIR /app

# Install dependencies without lock file
COPY package.json /app/package.json
RUN yarn install --silent

# Get all remaining files
COPY . /app

# Generate static files
RUN yarn run generate

FROM nginx:stable-alpine

# Copy dist files (generated) from builder layer into this (lightweight) nginx image
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose the port
EXPOSE 3028

LABEL \
  org.opencontainers.image.vendor="IntellectualSites" \
  org.opencontainers.image.title="schematic-web" \
  org.opencontainers.image.description="Frontend for arkitektonika" \
  org.opencontainers.image.url="https://schematic.cloud/" \
  org.opencontainers.image.url="https://github.com/IntellectualSites" \
  org.opencontainers.image.source="https://github.com/IntellectualSites/schematic.cloud" \
  com.docker.image.source.entrypoint=Dockerfile

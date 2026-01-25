# n8n with Chromium for Raspberry Pi (Docker)

Running Puppeteer on a Raspberry Pi (ARM64 architecture) requires a custom Docker image because the standard Google Chrome binaries do not match the ARM architecture, and the default n8n image is often based on Alpine Linux which needs specific Chromium packages.

Follow these steps to build a custom n8n image that includes Chromium.

## 1. Create a `Dockerfile`

Create a new file named `Dockerfile` on your Raspberry Pi:

```dockerfile
# Start from the official n8n image
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install Chromium and necessary fonts/dependencies for ARM64
# Note: We use 'chromium' instead of 'google-chrome-stable' for ARM compatibility
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    npm

# Tell Puppeteer to skip installing Chrome (we will use the system Chromium)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Switch back to the node user
USER node
```

## 2. Build the Image

Run this command in the same directory as your Dockerfile:

```bash
docker build -t n8n-chromium-rpi .
```

*This process might take a few minutes on a Raspberry Pi.*

## 3. Update your Docker Compose (or Run Command)

Modify your `docker-compose.yml` to use your new local image instead of `n8nio/n8n:latest`.

```yaml
version: "3"
services:
  n8n:
    image: n8n-chromium-rpi  # <--- CHANGE THIS
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=your-n8n-domain.com
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://your-n8n-domain.com/
      # Important: Pass the Puppeteer variables
      - PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
      - PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
    volumes:
      - ./n8n_data:/home/node/.n8n
```

## 4. Restart n8n

```bash
docker-compose up -d
```

## 5. Configure n8n Puppeteer Node

When using the **Puppeteer** node in your n8n workflow:

1.  Open the Puppeteer node settings.
2.  Enable **"Launch Arguments"** options (if available or needed).
3.  Add the argument: `--no-sandbox` (This is often required in Docker).
4.  The node should now pick up the system Chromium automatically via the `PUPPETEER_EXECUTABLE_PATH` environment variable.

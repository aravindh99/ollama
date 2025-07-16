# Multi-stage build for smaller image
FROM ollama/ollama as model-stage

# Pull the model in the first stage
RUN ollama serve & \
    sleep 10 && \
    ollama pull tinyllama:1.1b && \
    pkill ollama

# Production stage
FROM ollama/ollama

# Copy model from previous stage
COPY --from=model-stage /root/.ollama /root/.ollama

# Install Node.js 18 (LTS)
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Create non-root user for security
RUN useradd -m -u 1001 appuser && chown -R appuser:appuser /app /root/.ollama
USER appuser

# Expose port
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3001/health || exit 1

# Start both services
CMD ["bash", "-c", "ollama serve & sleep 15 && node server.js"]
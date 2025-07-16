# Simple Dockerfile for Google Cloud Run
FROM ollama/ollama

# Install Node.js
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Expose port
EXPOSE 3001

# Start script that pulls model and runs server
CMD ["bash", "-c", "ollama serve & sleep 10 && ollama pull tinyllama:1.1b && node server.js"]
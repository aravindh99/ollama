# Aravindh's AI Chat Assistant

Simple AI chatbot for portfolio website using TinyLlama with personal data.

## Local Setup

1. Install Ollama: https://ollama.ai
2. Pull the model: `ollama pull tinyllama:1.1b`
3. Install dependencies: `npm install`
4. Start server: `npm start`
5. Test: `curl -X POST http://localhost:3001/ask -H "Content-Type: application/json" -d '{"question": "hi"}'`

## Deploy to Google Cloud Run (Free)

### Prerequisites
- Google Cloud account (free tier)
- Install Google Cloud CLI

### Deploy Steps
```bash
# 1. Login to Google Cloud
gcloud auth login

# 2. Set your project
gcloud config set project YOUR_PROJECT_ID

# 3. Deploy directly from source
gcloud run deploy aravindh-ai-chat \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --timeout 300

# 4. Done! You'll get a URL like: https://aravindh-ai-chat-xxx.run.app
```

### Google Cloud Free Tier
- 2 million requests/month
- 1GB memory (perfect for TinyLlama 600MB)
- 180,000 CPU-seconds/month
- More than enough for a portfolio chatbot

## Connect to React Portfolio

```javascript
const API_URL = 'https://your-cloud-run-url.run.app';

const askAI = async (question) => {
  const response = await fetch(`${API_URL}/ask`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ question })
  });
  return response.json();
};
```

That's it! Simple and free.
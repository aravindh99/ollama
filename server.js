const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const fs = require("fs");

const { ChatOllama } = require("@langchain/ollama");
const { RunnableSequence } = require("@langchain/core/runnables");

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Health check endpoint
app.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});


const bio = fs.readFileSync("./data/aravindh.md", "utf-8");

// Model configuration
const ollama = new ChatOllama({
  model: "tinyllama:1.1b",           // Small and works great for free hosting
  baseUrl: process.env.OLLAMA_BASE_URL || "http://localhost:11434",
  temperature: 0.8,                  // A bit more personality
});



const chain = RunnableSequence.from([
  (input) => `You're Aravindh’s AI assistant. Be friendly, casual, and respond like a person — short replies, no essays. Here's info about him:\n\n${bio}\n\nUser: ${input.question}`,
  ollama,
]);


app.post("/ask", async (req, res) => {
  try {
    const { question } = req.body;

    if (!question || question.trim() === "") {
      return res.status(400).json({
        error: "Question is required",
        response: "hey! you gotta ask me something 😅"
      });
    }

    console.log(`Question received: ${question}`);
    const answer = await chain.invoke({ question: question.trim() });

    res.json({
      response: answer.content,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    console.error("Error processing question:", err);
    res.status(500).json({
      error: "Internal server error",
      response: "oops something went wrong 😅 try again in a sec!"
    });
  }
});


const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});


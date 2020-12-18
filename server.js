const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/ping', (req, res) => res.send("PONG"));
app.get('/round1', (req, res) => {
  const data = {
    questions: [
      "What is Question 1?",
      "What is Question 2?",
      "What is Question 3?",
      "What is Question 4?",
      "What is Question 5?",
      "What is Question 6?",
      "What is Question 7?",
      "What is Question 8?",
      "What is Question 9?",
      "What is Question 10?"
    ]
  }
  res.json(data)
})
app.listen(8080)
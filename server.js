const express = require("express");
const app = express();
const port = process.env.PORT || 8080;

app.get("/ping", (req, res) => res.send("PONG"));
app.get("/round:id", (req, res) => {
  const data = [
    {
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
        "What is Question 10?",
      ],
    },
    {
      questions: [
        "What is Love?",
        "What is Baby Don't Hurt Me?",
        "What is No More?",
        "Who will never give you up?",
      ],
    },
  ];

  let roundData = data[req.params.id];
  if (!roundData) roundData = data[0];
  res.json(roundData);
});
app.listen(8080);

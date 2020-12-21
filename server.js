const express = require('express');
const app = express();
const sqlite3 = require('sqlite3');

let db = new sqlite3.Database("./db/trivia.db", (err) => {
  if (err) {
    console.error(err.message);
    throw err;
  }
});

app.get('/ping', (req, res) => res.send("PONG"));
app.get('/round:id', (req, res) => {
  db.all("SELECT * FROM questions WHERE round = ?", [req.params.id], (err, rows) => {
    if (err) {
      res.status(400).message({ "error": err.message });
      return
    } else {
      res.json({ questions: rows.map((row) => row.question) })
    }
  });
})
app.listen(8080)
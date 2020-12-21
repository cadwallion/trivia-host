const sqlite3 = require('sqlite3');
const db = new sqlite3.Database("./db/trivia.db");

db.serialize(() => {
  console.log("Creating table questions");
  db.run("CREATE TABLE IF NOT EXISTS questions \
    ( \
      id INTEGER PRIMARY KEY AUTOINCREMENT, \
      round INTEGER, \
      question TEXT, \
      answer TEXT \
    )", (err) => {
    if (err) {
      console.log(err);
      throw err;
    }
  });

  console.log("Populating seed data...");
  let insertSql = "INSERT INTO questions (round, question, answer) VALUES (?,?, ?)";
  for (round = 1; round < 10; round++) {
    for (question_number = 1; question_number < 11; question_number++) {
      let question = "What is Question " + question_number + "?";
      let answer = "This";
      db.run(insertSql, [round, question, answer], (err) => {
        if (err) {
          console.log(err);
          throw err;
        }
      })
    }
  }

  console.log("Database created and seeded!");
});
# trivia-host - An app for hosting trivia

This is a project to make hosting Trivia easier than a shared screen.  Spin it up, feed it questions, give folks the URL.  It is run as a NodeJS server and a React frontend.

# Development

To begin development, run `npm install` to retrieve dependencies.  The backend will need a database setup, so run `node setupDB.js` to create a SQLite database and populate with fake data.  From there, you can either run `npm start` to trigger both the frontend (found at http://localhost:3000/) and the backend (found at http://localhost:8080/).  You can choose to run them as separate processes in separate terminals by running `npm run start-backend` and `npm run start-frontend`.  The `package.json` has been updated to proxy calls to the backend on 8080 to alleviate CORS limitations in development.

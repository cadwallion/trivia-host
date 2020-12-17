const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/ping', (req, res) => res.send("PONG"));
app.listen(8080)
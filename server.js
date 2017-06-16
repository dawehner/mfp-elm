const express = require('express');
const cors = require('cors');
const axios = require('axios');

const feedFurious = require('feed-furious');

const app = express();

app.use(cors());

app.get('/music', function (req, res) {
  axios.get('http://musicforprogramming.net/rss.php')
    .then((ares) => {
    const result = feedFurious.parse(ares.data);
    res.json(result);
  }).catch(console.error);
});


app.listen(3123, () => console.log('Listen on 3123'));

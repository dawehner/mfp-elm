'use strict';

require('./index.html');

const Elm = require('./Main.elm').Elm;

Elm.Main.init({
  node: document.getElementById('elm')
});
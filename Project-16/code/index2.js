'use strict'

const shows = {
    action: 'Planet Earth II (2016)',
    fantasy: 'Inception (2010)',
    thriller: 'Band of Brothers (2001)',
    horror: 'Chernobyl (2019)'
}

exports.handler = function (event, context, callback) {
var response = {
  isBase64Encoded: false,
  body: JSON.stringify(shows),
  headers: {
      'Access-Control-Allow-Origin': '*',
  },
  statusCode: 200,
  }

// callback is sending HTML back
  callback(null, response)
}
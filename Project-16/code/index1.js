'use strict'

const movies = {
    action: 'Desperado (1995)',
    fantasy: 'Inception (2010)',
    thriller: 'Psycho (1960)',
    horror: 'Black Swan (2010)'
}

exports.handler = function (event, context, callback) {
var response = {
  isBase64Encoded: false,
  body: JSON.stringify(movies),
  headers: {
      'Access-Control-Allow-Origin': '*',
  },
  statusCode: 200,
  }
// callback is sending HTML back
  callback(null, response)
}

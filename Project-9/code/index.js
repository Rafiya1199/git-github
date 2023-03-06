// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
// Set the region 
AWS.config.update({region: "us-east-1"});
exports.handler = async function (event) {
  console.log('EVENT: ', event)
  // Extract the properties from the event body
  const { senderEmail, senderName, senderPhoneNumber, message } = JSON.parse(event.body)

  // Create sendEmail params 
  var params = {
    Destination: {
      ToAddresses: ["rmohamed@thecloudforce.com"],
    },
        // Interpolate the data in the strings to send
    Message: {
      Body: {
        Text: { 
            Data: `You just got a message from ${senderName}
            Email ID: ${senderEmail}
            Phone Number: ${senderPhoneNumber}
            Message: ${message}` 
        },
      },
      Subject: { Data: `Message from ${senderName}` },
    },
    Source: "rmohamed@thecloudforce.com",
};
await new AWS.SES({apiVersion: '2010-12-01'}).sendEmail(params).promise();
//Get formatted Lambda proxy response
return {
        isBase64Encoded: false,
        body: JSON.stringify({ message: "API invoked successfully" }),
        headers: {
            'Access-Control-Allow-Origin': '*',
        },
        statusCode: 200,
    };
};
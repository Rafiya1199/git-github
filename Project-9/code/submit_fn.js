const form = document.querySelector("form");
form.addEventListener("submit", (event) => {
  // prevent the form submit from refreshing the page
  event.preventDefault();

  const { name, email, message, phone } = event.target;

    // Use your API endpoint URL you copied from the previous step
  const endpoint =
    "https://karsood7ml.execute-api.us-east-1.amazonaws.com/default/sendContactEmail";
  // We use JSON.stringify here so the data can be sent as a string via HTTP
    const body = JSON.stringify({
    senderName: name.value,
    senderEmail: email.value,
    senderPhoneNumber: phone.value,
    message: message.value
  });
  const requestOptions = {
    method: "POST",
    body
  };

  fetch(endpoint, requestOptions)
    .then((response) => {
      if (!response.ok) throw new Error("Error in fetch");
      return response.json();
    })
    .then((response) => {
      document.getElementById("result-text").innerText =
        "Email sent successfully!";
    })
    .catch((error) => {
      document.getElementById("result-text").innerText =
        "An unkown error occured.";
    });
});
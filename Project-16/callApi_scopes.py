import boto3
import requests
import json

HOST = "https://rfrqhqy0wg.execute-api.us-east-1.amazonaws.com"
STAGE = "test/movies"
BASE_URL = f"{HOST}/{STAGE}"

token_url = "https://example-domain0453.auth.us-east-1.amazoncognito.com/oauth2/token"

CLIENT_ID = "646imcjlbt6484e2u79ek90nu6"
CLIENT_SECRET = "12tfas6q2krui4b9u69e04umjh64kv3h9k12jclmg7e2va9p7flq"

# TODO: Replace these with your own scopes - separated with a space
#LIST_OF_SCOPES = "https://example.com/read"


def get_access_token():

    body = {
        "grant_type": "client_credentials",
        # "scope": LIST_OF_SCOPES
    }

    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }

    response = requests.post(
        url=token_url,
        data=body,
        auth=(CLIENT_ID, CLIENT_SECRET),
        headers=headers
    )

    return response.json()["access_token"]

access_token = get_access_token()
print("Access token: ", access_token)
r1 = requests.get(f"{BASE_URL}", headers={"Authorization": access_token}) # the test call
print("API Response: ", r1.status_code, r1.reason)
print("API content: ", r1.content)
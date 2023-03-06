import requests

def handler(event, context):
    response = requests.get('https://api.github.com')
    return response.json()        
import json
import requests
import sys


def send_request(url, method, headers, body):
    global response
    if method == 'POST':
        response = requests.post(url, data=body, headers=headers)
    elif method == 'PUT':
        response = requests.put(url, data=body, headers=headers)
    elif method == 'GET':
        response = requests.get(url, headers=headers)
    return json.loads(response.text)


if len(sys.argv) < 4:
    print("Missing parameters")
    exit()

projectId = sys.argv[1]
version = sys.argv[2]
url = sys.argv[3]

print("Logging in...")
auth = send_request(f"{url}/api/auth", 'POST',
                    {
                        'Content-Type': 'application/json',
                        'accept': 'application/json'
                    },
                    json.dumps(
                        {
                            "password": "250691mp",
                            "username": "admin"
                        }
                    ).encode('utf-8')
                    )
if 'message' in auth:
    print("Couldn't log in")
    exit()

jwtToken = auth['jwt']
if jwtToken:
    print("Logged in...")

stacks = send_request(f"{url}/api/stacks", 'GET', {
    'accept': 'application/json',
    'Authorization': jwtToken
}, '')

stackId = ''
endpointId = ''
if len(stacks) == 0:
    print("No stacks found...")
    exit()

for stack in stacks:
    if stack['Name'] == projectId:
        stackId = stack['Id']
        endpointId = stack['EndpointId']


if stackId == "" and endpointId == "":
    print("Stack not found...")
    exit()

print("Updating stack...")
response = send_request(f"{url}/api/stacks/{stackId}/git?endpointId={endpointId}", 'PUT',
                        {
                            'Content-Type': 'application/json',
                            'accept': 'application/json',
                            'Authorization': jwtToken
                        },
                        json.dumps(
                            {
                                "repositoryReferenceName": f"refs/heads/{version}"
                            }
                        ).encode('utf-8')
                        )

if 'message' in response:
    print("Couldn't update the stack")
    exit()

print("Stack updated!")


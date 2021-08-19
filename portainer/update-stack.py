import json
import sys

import requests


def send_request(url, method, headers, body):
    global response
    if method == 'POST':
        response = requests.post(url, data=body, headers=headers)
    elif method == 'PUT':
        response = requests.put(url, data=body, headers=headers)
    elif method == 'GET':
        response = requests.get(url, headers=headers)
    return json.loads(response.text)


def authenticate(url, userName, password):
    print("Logging in...")
    auth = send_request(
        f"{url}/api/auth", 'POST',
        {
            'Content-Type': 'application/json',
            'accept': 'application/json'
        },
        json.dumps(
            {
                "password": password,
                "username": userName
            }
        ).encode('utf-8')
    )
    if 'jwt' in auth:
        print("Logged in...")
        return auth['jwt']

    print("Couldn't log in")


def findStack(url, jwtToken, projectId):
    stacks = send_request(f"{url}/api/stacks", 'GET', {
        'accept': 'application/json',
        'Authorization': jwtToken
    }, '')

    if len(stacks) == 0:
        print("No stacks found...")
        exit()

    for stack in stacks:
        if stack['Name'] == projectId:
            return stack


def getStackFile(url, stack, jwtToken):
    print("Getting stack file...")
    stackId = stack['Id']
    response = send_request(
        f"{url}/api/stacks/{stackId}/file", 'GET',
        {
            'accept': 'application/json',
            'Authorization': jwtToken
        },
        ''
    )

    if 'StackFileContent' in response:
        return response['StackFileContent']

    print("Couldn't get the stack file")
    exit()


def updateStackGit(url, jwtToken, stack, version):
    print("Updating stack...")
    stackId = stack['Id']
    endpointId = stack['EndpointId']
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


def updateStack(url, jwtToken, stack):
    print("Updating stack...")
    stackId = stack['Id']
    endpointId = stack['EndpointId']
    env = stack['Env']
    stackFile = getStackFile(url, stack, jwtToken)
    response = send_request(f"{url}/api/stacks/{stackId}?endpointId={endpointId}", 'PUT',
                            {
                                'accept': 'application/json',
                                'Authorization': jwtToken
                            },
                            json.dumps(
                                {
                                    "env": env,
                                    "prune": False,
                                    "stackFileContent": stackFile
                                }
                            ).encode('utf-8')
                            )

    if 'message' in response:
        print("Couldn't update the stack")
        exit()

    print("Stack updated!")


if len(sys.argv) < 4:
    print("Missing parameters")
    exit()

projectId = sys.argv[1]
version = sys.argv[2]
url = sys.argv[3]
userName = sys.argv[4]
password = sys.argv[5]

jwtToken = authenticate(url, userName, password)

stack = findStack(url, jwtToken, projectId)

# updateStackGit(url, jwtToken, stack, version)
updateStack(url, jwtToken, stack)

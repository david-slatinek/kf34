import requests

if __name__ == "__main__":
    url = 'localhost:5000/graphql'
    query = """
            mutation AddData($value: Float!, $device_type: DeviceType!) {
                addData(value: $value, device_type: $device_type) {
                    success,
                    error
                }
            }
        """
    variables = {'value': 24, 'device_type': "TEMPERATURE"}

    headers = {'X-API-Key': '%s' % ""}

    r = requests.post(url=url, json={'query': query, 'variables': variables}, headers=headers)
    print(r.text)

namespace: aos
flow:
  name: test
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: 'http://localhost:8080/accountservice/accountrest/api/v1/register'
            - body: |-
                ${'''
                {
                  "accountType": "USER",
                  "address": "Za Brumlovkou 5",
                  "allowOffersPromotion": true,
                  "cityName": "Prague",
                  "country": "AUSTRALIA_AU",
                  "email": "petr.panuska@mf.com",
                  "firstName": "Petr",
                  "lastName": "Panuska",
                  "loginName": "pepan5",
                  "password": "Cloud@123",
                  "phoneNumber": "123456",
                  "stateProvince": "None",
                  "zipcode": "13000"
                }
                '''}
            - content_type: application/json
            - request_character_set: ' '
            - method: POST
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 110
        'y': 124
        navigate:
          366846a5-a24a-aa3a-e659-a23a14f5c19f:
            targetId: ced606da-1fc8-84b5-4e8e-13d6e13c3240
            port: SUCCESS
    results:
      SUCCESS:
        ced606da-1fc8-84b5-4e8e-13d6e13c3240:
          x: 306
          'y': 132

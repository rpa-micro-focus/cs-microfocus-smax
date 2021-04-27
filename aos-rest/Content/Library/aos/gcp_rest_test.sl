namespace: aos
flow:
  name: gcp_rest_test
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: 'https://photoslibrary.googleapis.com/v1/mediaItems'
            - auth_type: anonymous
        navigate:
          - FAILURE: on_failure
  results:
    - FAILURE
extensions:
  graph:
    steps:
      http_client_action:
        x: 102
        'y': 126

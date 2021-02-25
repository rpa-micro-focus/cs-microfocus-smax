namespace: io.cloudslang.microfocus.dnd._operations
flow:
  name: artifact_http_action
  inputs:
    - url
    - method
    - body:
        required: false
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'%s/%s/dnd/rest%s' % (get_sp('io.cloudslang.microfocus.smax.smax_url'), get_sp('io.cloudslang.microfocus.smax.smax_tenant_id'), url)}"
            - auth_type: basic
            - username: "${get_sp('io.cloudslang.microfocus.smax.smax_username')}"
            - password:
                value: "${get_sp('io.cloudslang.microfocus.smax.smax_password')}"
                sensitive: true
            - proxy_host: "${get_sp('io.cloudslang.microfocus.smax.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.smax.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.smax.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.smax.proxy_password')}"
                sensitive: true
            - body: '${body}'
            - content_type: application/xml
            - method: '${method}'
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - error_message: '${error_message}'
    - status_code: '${status_code}'
    - return_code: '${return_code}'
    - response_headers: '${response_headers}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 55
        'y': 94
        navigate:
          ff4a39f3-c0e1-251b-b9d3-5ae9c213ff42:
            targetId: 70b5992d-86a0-d6f3-b660-8e8ff55b77bd
            port: SUCCESS
    results:
      SUCCESS:
        70b5992d-86a0-d6f3-b660-8e8ff55b77bd:
          x: 242
          'y': 94

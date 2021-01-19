########################################################################################################################
#!!
#! @description: Template of HTTP operations against SMAX REST API service. 
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax._operations
flow:
  name: smax_http_action
  inputs:
    - url
    - method
    - token:
        required: true
    - body:
        required: false
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'%s%s' % (get_sp('io.cloudslang.microfocus.smax.smax_url'), url)}"
            - headers: "${'Cookie: SMAX_AUTH_TOKEN=%s' % token}"
            - body: '${body}'
            - content_type: application/json
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
        x: 75
        'y': 80
        navigate:
          082ef547-d9e8-c203-f43b-245b1d8c18c9:
            targetId: 923e08a2-0ebb-fc05-9e80-71dcbbaf2e0e
            port: SUCCESS
    results:
      SUCCESS:
        923e08a2-0ebb-fc05-9e80-71dcbbaf2e0e:
          x: 264
          'y': 80

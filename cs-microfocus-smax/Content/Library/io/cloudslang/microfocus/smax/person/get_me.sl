########################################################################################################################
#!!
#! @output user_id: User ID
#! @output user_json: JSON document describing the logged user
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax.person
flow:
  name: get_me
  inputs:
    - token
  workflow:
    - smax_http_action:
        do:
          io.cloudslang.microfocus.smax._operations.smax_http_action:
            - url: "${'/rest/%s/personalization/person/me' % get_sp('io.cloudslang.microfocus.smax.smax_tenant_id')}"
            - method: GET
            - token: '${token}'
        publish:
          - user_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${user_json}'
            - json_path: '$.entities[0].properties.Id'
        publish:
          - user_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - user_id: '${user_id}'
    - user_json: '${user_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      smax_http_action:
        x: 100
        'y': 90
      json_path_query:
        x: 263
        'y': 94
        navigate:
          c46ca351-2b39-38e8-ac46-c0d3446a770c:
            targetId: d7b5730a-485a-8b18-a909-310f71ae1e77
            port: SUCCESS
    results:
      SUCCESS:
        d7b5730a-485a-8b18-a909-310f71ae1e77:
          x: 407
          'y': 91

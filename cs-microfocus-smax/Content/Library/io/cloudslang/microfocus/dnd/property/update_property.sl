namespace: io.cloudslang.microfocus.dnd.property
flow:
  name: update_property
  inputs:
    - property_id
    - property_json
  workflow:
    - csa_http_action:
        do:
          io.cloudslang.microfocus.dnd._operations.csa_http_action:
            - url: "${'/property/%s' % property_id}"
            - method: PUT
            - body: '${property_json}'
        publish:
          - failure: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - failure: '${failure}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      csa_http_action:
        x: 43
        'y': 70
        navigate:
          dcd20138-5594-cd7c-f09c-98c4ca27a715:
            targetId: 80459204-80ea-1ea9-a967-933f8c7e4bed
            port: SUCCESS
    results:
      SUCCESS:
        80459204-80ea-1ea9-a967-933f8c7e4bed:
          x: 328
          'y': 71

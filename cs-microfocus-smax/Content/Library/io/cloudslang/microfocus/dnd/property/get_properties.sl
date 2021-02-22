namespace: io.cloudslang.microfocus.dnd.property
flow:
  name: get_properties
  inputs:
    - token
    - instance_id
    - component_id
  workflow:
    - dnd_http_action:
        do:
          io.cloudslang.microfocus.dnd._operations.dnd_http_action:
            - url: "${'/dnd-operations-gateway/v1/instance/%s/components/%s/propertyValues' % (instance_id, component_id)}"
            - method: GET
            - token: '${token}'
        publish:
          - properties_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - properties_json: '${properties_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      dnd_http_action:
        x: 61
        'y': 96
        navigate:
          47c6bc07-f5c1-3b2a-3774-c82208fde7ba:
            targetId: bb30c1c5-ad78-03da-6329-1f295def3c5e
            port: SUCCESS
    results:
      SUCCESS:
        bb30c1c5-ad78-03da-6329-1f295def3c5e:
          x: 273
          'y': 98

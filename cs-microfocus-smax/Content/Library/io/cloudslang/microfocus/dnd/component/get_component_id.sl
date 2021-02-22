namespace: io.cloudslang.microfocus.dnd.component
flow:
  name: get_component_id
  inputs:
    - token
    - instance_id
    - component_name
  workflow:
    - get_components:
        do:
          io.cloudslang.microfocus.dnd.component.get_components:
            - token: '${token}'
            - instance_id: '${instance_id}'
        publish:
          - components_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${components_json}'
            - json_path: "${\"$.components.[?(@.displayName=='%s')].id\" % component_name}"
        publish:
          - component_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - component_id: '${component_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_components:
        x: 45
        'y': 97
      json_path_query:
        x: 199
        'y': 97
        navigate:
          0f632fbe-ebde-8dec-64e4-68802083d0c1:
            targetId: bb30c1c5-ad78-03da-6329-1f295def3c5e
            port: SUCCESS
    results:
      SUCCESS:
        bb30c1c5-ad78-03da-6329-1f295def3c5e:
          x: 368
          'y': 94

namespace: io.cloudslang.microfocus.dnd.property
flow:
  name: get_property_value
  inputs:
    - token
    - instance_id
    - component_id
    - property_name
  workflow:
    - get_properties:
        do:
          io.cloudslang.microfocus.dnd.property.get_properties:
            - token: '${token}'
            - instance_id: '${instance_id}'
            - component_id: '${component_id}'
        publish:
          - properties_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${properties_json}'
            - json_path: "${\"$.component.propertyValues.[?(@.name=='%s')].propertyValue\" % property_name}"
        publish:
          - property_value: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - property_value: '${property_value}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_properties:
        x: 59
        'y': 101
      json_path_query:
        x: 212
        'y': 100
        navigate:
          0f632fbe-ebde-8dec-64e4-68802083d0c1:
            targetId: bb30c1c5-ad78-03da-6329-1f295def3c5e
            port: SUCCESS
    results:
      SUCCESS:
        bb30c1c5-ad78-03da-6329-1f295def3c5e:
          x: 368
          'y': 94

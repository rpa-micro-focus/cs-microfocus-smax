namespace: Integrations.microfocus.smax
flow:
  name: update_component_property_value
  inputs:
    - instance_id
    - component_name
    - property_name
    - property_value
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.smax.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_component_id
    - get_component_id:
        do:
          io.cloudslang.microfocus.dnd.component.get_component_id:
            - token: '${token}'
            - instance_id: '${instance_id}'
            - component_name: '${component_name}'
        publish:
          - component_id
        navigate:
          - SUCCESS: get_property_id
          - FAILURE: on_failure
    - get_property_id:
        do:
          io.cloudslang.microfocus.dnd.property.get_property_id:
            - token: '${token}'
            - instance_id: '${instance_id}'
            - component_id: '${component_id}'
            - property_name: '${property_name}'
        publish:
          - property_id
        navigate:
          - SUCCESS: set_property_value
          - FAILURE: on_failure
    - set_property_value:
        do:
          io.cloudslang.microfocus.dnd.property.set_property_value:
            - property_id: '${property_id}'
            - property_value: '${property_value}'
        publish:
          - original_property_json
          - updated_property_json
          - failure
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - component_id: '${component_id}'
    - property_id: '${property_id}'
    - original_property_json: '${original_property_json}'
    - updated_property_json: '${updated_property_json}'
    - failure: '${failure}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 40
        'y': 74
      get_component_id:
        x: 215
        'y': 75
      get_property_id:
        x: 392
        'y': 75
      set_property_value:
        x: 567
        'y': 75
        navigate:
          d25291ea-0657-1a7d-9e23-42a12ffd156a:
            targetId: e3ba52f6-6707-983d-5f1e-70bb84cfa5c7
            port: SUCCESS
    results:
      SUCCESS:
        e3ba52f6-6707-983d-5f1e-70bb84cfa5c7:
          x: 740
          'y': 77

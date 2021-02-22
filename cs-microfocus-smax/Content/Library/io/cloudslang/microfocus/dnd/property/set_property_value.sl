namespace: io.cloudslang.microfocus.dnd.property
flow:
  name: set_property_value
  inputs:
    - property_id
    - property_value
  workflow:
    - get_property:
        do:
          io.cloudslang.microfocus.dnd.property.get_property:
            - property_id: '${property_id}'
        publish:
          - property_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_value
    - add_value:
        do:
          io.cloudslang.base.json.add_value:
            - json_input: '${property_json}'
            - json_path: property_value
            - value: '${property_value}'
        publish:
          - updated_property_json: '${return_result}'
        navigate:
          - SUCCESS: update_property
          - FAILURE: on_failure
    - update_property:
        do:
          io.cloudslang.microfocus.dnd.property.update_property:
            - property_id: '${property_id}'
            - property_json: '${updated_property_json}'
        publish:
          - failure
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - original_property_json: '${property_json}'
    - updated_property_json: '${updated_property_json}'
    - failure: '${failure}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_property:
        x: 40
        'y': 76
      add_value:
        x: 228
        'y': 78
      update_property:
        x: 414
        'y': 78
        navigate:
          02b47f16-d841-cc99-3b7e-584cef37bee8:
            targetId: d097c49e-5225-a218-a274-a1b47c02a3c4
            port: SUCCESS
    results:
      SUCCESS:
        d097c49e-5225-a218-a274-a1b47c02a3c4:
          x: 609
          'y': 79

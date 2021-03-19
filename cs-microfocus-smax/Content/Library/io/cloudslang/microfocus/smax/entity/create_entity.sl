########################################################################################################################
#!!
#! @description: Creates an entity of this given type with the given properties.
#!
#! @input entity_type: Request, Incident, ...
#! @input entity_properties: JSON document describing the entity properties
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax.entity
flow:
  name: create_entity
  inputs:
    - token
    - entity_type
    - entity_properties
  workflow:
    - smax_http_action:
        do:
          io.cloudslang.microfocus.smax._operations.smax_http_action:
            - url: "${'/rest/%s/ems/bulk' % get_sp('io.cloudslang.microfocus.smax.smax_tenant_id')}"
            - method: POST
            - token: '${token}'
            - body: |-
                ${'''
                {
                    "entities": [{
                        "entity_type": "%s",
                        "properties": %s
                    }],
                    "operation": "CREATE"
                }
                ''' % (entity_type, entity_properties)}
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
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
      smax_http_action:
        x: 37
        'y': 73
        navigate:
          ea8fbfd9-9b16-ae27-69be-818bcb9fdae1:
            targetId: 816f3027-cb53-c017-f5af-15af080e77b3
            port: SUCCESS
    results:
      SUCCESS:
        816f3027-cb53-c017-f5af-15af080e77b3:
          x: 247
          'y': 75

########################################################################################################################
#!!
#! @description: Deletes the given SMAX offering.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax.offering
flow:
  name: delete_offering
  inputs:
    - token
    - offering_id
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
                    "entities": [
                      {
                        "entity_type": "Offering",
                        "properties": {
                          "Id": "%s"
                        }
                      }
                    ],
                    "operation": "DELETE"
                }
                ''' % offering_id}
        publish:
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: '$.entity_result_list[0].completion_status'
        publish:
          - completion_status: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${completion_status}'
            - second_string: OK
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      smax_http_action:
        x: 41
        'y': 77
      json_path_query:
        x: 40
        'y': 269
      string_equals:
        x: 222
        'y': 271
        navigate:
          753a98f3-d50b-3e70-22bd-790927fe6cd4:
            targetId: 7981f110-caf4-7c45-5a5e-be30d4f1040a
            port: SUCCESS
    results:
      SUCCESS:
        7981f110-caf4-7c45-5a5e-be30d4f1040a:
          x: 219
          'y': 83

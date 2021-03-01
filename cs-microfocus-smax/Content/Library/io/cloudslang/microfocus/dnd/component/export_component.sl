########################################################################################################################
#!!
#! @description: Exports a component and its templates (if given).
#!
#! @input component_template_ids: List of component templates IDs separated by comma
#! @input file: Zip file where the exported component will be saved
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.dnd.component
flow:
  name: export_component
  inputs:
    - user_id
    - component_palette_id
    - component_id
    - component_template_ids:
        required: false
    - file:
        required: true
  workflow:
    - artifact_http_action:
        do:
          io.cloudslang.microfocus.dnd._operations.artifact_http_action:
            - url: "${'/export/list/%s?userIdentifier=%s' % (component_palette_id, user_id)}"
            - method: POST
            - content_type: application/json
            - body: |-
                ${'''
                {
                  "members": [
                    {
                      "component_type_id": "%s",
                      "component_template_id_list": %s
                    }
                  ]
                }
                ''' % (component_id, '[]' if component_template_ids is None else component_template_ids.split(','))}
            - file: '${file}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      artifact_http_action:
        x: 48
        'y': 116
        navigate:
          31cf965e-eb2f-3338-dfb4-e47c98ed2f3f:
            targetId: c5e583e4-f693-879d-6cb7-e00a9d17d789
            port: SUCCESS
    results:
      SUCCESS:
        c5e583e4-f693-879d-6cb7-e00a9d17d789:
          x: 243
          'y': 115

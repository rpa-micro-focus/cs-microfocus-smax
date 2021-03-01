namespace: io.cloudslang.microfocus.dnd.artifact
flow:
  name: get_artifact
  inputs:
    - user_id
    - artifact_id
  workflow:
    - artifact_http_action:
        do:
          io.cloudslang.microfocus.dnd._operations.artifact_http_action:
            - url: "${'/artifact/%s?userIdentifier=%s' % (artifact_id, user_id)}"
            - method: GET
            - content_type: application/xml
        publish:
          - artifact_xml: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - artifact_xml: '${artifact_xml}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      artifact_http_action:
        x: 40
        'y': 74
        navigate:
          8a9bd345-5233-555d-fbd7-6e357484dbf7:
            targetId: ea7bc82c-f5f9-2834-1abd-6a877224f943
            port: SUCCESS
    results:
      SUCCESS:
        ea7bc82c-f5f9-2834-1abd-6a877224f943:
          x: 227
          'y': 75

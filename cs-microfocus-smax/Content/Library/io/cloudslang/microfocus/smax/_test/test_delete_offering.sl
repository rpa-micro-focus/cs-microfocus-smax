namespace: io.cloudslang.microfocus.smax._test
flow:
  name: test_delete_offering
  inputs:
    - offering_id
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.smax.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_offering
    - delete_offering:
        do:
          io.cloudslang.microfocus.smax.offering.delete_offering:
            - token: '${token}'
            - offering_id: '${offering_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 40
        'y': 76
      delete_offering:
        x: 217
        'y': 75
        navigate:
          d653415a-dc25-3089-ee47-c5987184a905:
            targetId: fccf80d2-51c9-6b69-183c-3584c18b73bb
            port: SUCCESS
    results:
      SUCCESS:
        fccf80d2-51c9-6b69-183c-3584c18b73bb:
          x: 403
          'y': 78

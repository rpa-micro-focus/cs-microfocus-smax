########################################################################################################################
#!!
#! @description: Authenticate against the given SMAX instance using the provided credentials.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax.authenticate
flow:
  name: get_token
  inputs:
    - smax_username:
        required: false
    - smax_password:
        required: false
        sensitive: true
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'%s/auth/authentication-endpoint/authenticate/token?TENANTID=%s' % (get_sp('io.cloudslang.microfocus.smax.smax_url'), get_sp('io.cloudslang.microfocus.smax.smax_tenant_id'))}"
            - body: "${'{\"login\":\"%s\",\"password\":\"%s\"}' % (get('smax_username', get_sp('io.cloudslang.microfocus.smax.smax_username')), get('smax_password', get_sp('io.cloudslang.microfocus.smax.smax_password')))}"
            - method: POST
        publish:
          - token: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 83
        'y': 94
        navigate:
          5aa317f3-a1ed-f623-1a5f-1af1dd1fb505:
            targetId: 38ea8c17-3b6e-a2ef-87ff-fdb41583d6d0
            port: SUCCESS
    results:
      SUCCESS:
        38ea8c17-3b6e-a2ef-87ff-fdb41583d6d0:
          x: 277
          'y': 96

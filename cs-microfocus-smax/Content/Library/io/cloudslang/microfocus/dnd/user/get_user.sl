namespace: io.cloudslang.microfocus.dnd.user
flow:
  name: get_user
  workflow:
    - artifact_http_action:
        do:
          io.cloudslang.microfocus.dnd._operations.artifact_http_action:
            - url: "${'/login/%s/%s' % (get_sp('io.cloudslang.microfocus.smax.smax_tenant_id'), get_sp('io.cloudslang.microfocus.smax.smax_username'))}"
            - method: GET
        publish:
          - user_xml: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: xpath_query
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${user_xml}'
            - xpath_query: //person/id
            - query_type: value
        publish:
          - user_id: '${selected_value}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - user_xml: '${user_xml}'
    - user_id: '${user_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      artifact_http_action:
        x: 37
        'y': 76
      xpath_query:
        x: 214
        'y': 77
        navigate:
          a03e09d7-5370-b742-5282-7032cf1d0b52:
            targetId: 30088e17-ad40-8107-ef6a-47444eaa644e
            port: SUCCESS
    results:
      SUCCESS:
        30088e17-ad40-8107-ef6a-47444eaa644e:
          x: 381
          'y': 71

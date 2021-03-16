########################################################################################################################
#!!
#! @description: Retrieves list of subscriptions belonging to the given user, containing the given text and being in one of the given statuses.
#!
#! @input user_id: User ID the subscriptions belong to
#! @input search_text: Filter subscriptions containing this piece of text
#! @input statuses: Comma delimited list of statuses (no spaces in between): Paused, Active, Expired, Cancelled, Pending, Terminated, Retired
#!
#! @output subscriptions_json: JSON document describing the subscriptions
#! @output subscription_ids: Comma delimited list of subscription IDs
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax.subscription
flow:
  name: get_subscriptions
  inputs:
    - token
    - user_id:
        required: true
    - search_text:
        required: false
    - statuses:
        required: true
  workflow:
    - smax_http_action:
        do:
          io.cloudslang.microfocus.smax._operations.smax_http_action:
            - url: "${'/rest/%s/ess/subscription/getSubscriptionList' % get_sp('io.cloudslang.microfocus.smax.smax_tenant_id')}"
            - method: POST
            - token: '${token}'
            - body: |-
                ${'''
                {
                    "searchText":"%s",
                    "userId":"%s",
                    "status":%s
                }
                ''' % ('' if search_text is None else search_text, user_id, '["'+'","'.join(statuses.split(','))+'"]')}
        publish:
          - subscriptions_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${subscriptions_json}'
            - json_path: '$.entities.*.properties.Id'
        publish:
          - subscription_ids: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - subscriptions_json: '${subscriptions_json}'
    - subscription_ids: "${','.join(eval(subscription_ids))}"
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      smax_http_action:
        x: 93
        'y': 132
      json_path_query:
        x: 256
        'y': 135
        navigate:
          0dee49c7-a458-8ced-2c9e-f3b4a71b81ec:
            targetId: 26d78ae0-990d-3467-ebc8-1fcc3d95f44e
            port: SUCCESS
    results:
      SUCCESS:
        26d78ae0-990d-3467-ebc8-1fcc3d95f44e:
          x: 409
          'y': 132

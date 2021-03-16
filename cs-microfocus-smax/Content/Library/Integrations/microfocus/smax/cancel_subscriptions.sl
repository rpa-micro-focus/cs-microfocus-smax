########################################################################################################################
#!!
#! @description: Cancels all subscriptions that contains the given text, are in the given state and older than the given time limit (in millis).
#!
#! @input statuses: Comma delimited list of statuses (no spaces in between): Paused, Active, Expired, Cancelled, Pending, Terminated, Retired
#! @input filter_text: Which text the subsciption name should start with
#! @input time_limit: How old subscriptions should be cancelled (in millis)
#!
#! @output cancel_failed: List of subscription IDs whose cancellation failed
#!
#! @result FAILURE: If one or more subscription cancellation failed
#!!#
########################################################################################################################
namespace: Integrations.microfocus.smax
flow:
  name: cancel_subscriptions
  inputs:
    - statuses: 'Active,Terminated'
    - filter_text:
        required: false
    - time_limit: '90000000'
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.smax.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_me
    - get_me:
        do:
          io.cloudslang.microfocus.smax.person.get_me:
            - token: '${token}'
        publish:
          - user_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_subscriptions
    - get_subscriptions:
        do:
          io.cloudslang.microfocus.smax.subscription.get_subscriptions:
            - token: '${token}'
            - user_id: '${user_id}'
            - search_text: '${filter_text}'
            - statuses: '${statuses}'
        publish:
          - subscriptions_json
          - subscription_ids
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_millis
    - get_millis:
        do:
          io.cloudslang.base.datetime.get_millis: []
        publish:
          - time_now: '${time_millis}'
          - cancel_failed: ''
        navigate:
          - SUCCESS: list_iterator
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${subscription_ids}'
        publish:
          - subscription_id: '${result_string}'
        navigate:
          - HAS_MORE: get_start_time
          - NO_MORE: has_failed
          - FAILURE: on_failure
    - get_start_time:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${subscriptions_json}'
            - json_path: "${\"$.entities[?(@.properties.Id == '%s')].properties.StartDate\" % subscription_id}"
        publish:
          - time_subscription_started: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: is_subscription_old
          - FAILURE: on_failure
    - is_subscription_old:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(int(time_now) - int(time_subscription_started) > int(time_limit))}'
        navigate:
          - 'TRUE': cancel_subscription
          - 'FALSE': list_iterator
    - cancel_subscription:
        do:
          io.cloudslang.microfocus.smax.subscription.cancel_subscription:
            - token: '${token}'
            - user_id: '${user_id}'
            - subscription_id: '${subscription_id}'
        navigate:
          - FAILURE: note_failure
          - SUCCESS: list_iterator
    - note_failure:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
            - cancel_failed_in: '${cancel_failed}'
            - subscription_id: '${subscription_id}'
        publish:
          - cancel_failed: "${cancel_failed_in+subscription_id+','}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(cancel_failed) > 0)}'
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': SUCCESS
  outputs:
    - cancel_failed: "${'' if len(cancel_failed) == 0 else cancel_failed[:-1]}"
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_me:
        x: 32
        'y': 260
      has_failed:
        x: 612
        'y': 81
        navigate:
          99b3f49f-39b1-0d41-41a8-6da5f0a8658b:
            targetId: 11f6da47-2670-97a9-6960-bbb033d32578
            port: 'TRUE'
          c259dce9-dc88-d9a7-9356-e335a8a1dd85:
            targetId: 38c91957-d0b5-2079-7957-64c4177cf2bd
            port: 'FALSE'
      cancel_subscription:
        x: 284
        'y': 466
      get_subscriptions:
        x: 27
        'y': 466
      list_iterator:
        x: 383
        'y': 79
      get_millis:
        x: 185
        'y': 77
      get_token:
        x: 35
        'y': 73
      get_start_time:
        x: 557
        'y': 264
      is_subscription_old:
        x: 502
        'y': 465
      note_failure:
        x: 208
        'y': 259
    results:
      SUCCESS:
        38c91957-d0b5-2079-7957-64c4177cf2bd:
          x: 792
          'y': 84
      FAILURE:
        11f6da47-2670-97a9-6960-bbb033d32578:
          x: 790
          'y': 258

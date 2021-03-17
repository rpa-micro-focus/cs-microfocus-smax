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
          - SUCCESS: no_subscriptions
    - get_millis:
        do:
          io.cloudslang.base.datetime.get_millis: []
        publish:
          - time_now: '${time_millis}'
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
    - no_subscriptions:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(subscription_ids) == 0)}'
        publish:
          - cancel_failed: ''
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': get_millis
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
        x: 739
        'y': 261
        navigate:
          99b3f49f-39b1-0d41-41a8-6da5f0a8658b:
            targetId: 11f6da47-2670-97a9-6960-bbb033d32578
            port: 'TRUE'
          c259dce9-dc88-d9a7-9356-e335a8a1dd85:
            targetId: 38c91957-d0b5-2079-7957-64c4177cf2bd
            port: 'FALSE'
      cancel_subscription:
        x: 376
        'y': 614
      get_subscriptions:
        x: 178
        'y': 64
      list_iterator:
        x: 485
        'y': 261
      get_millis:
        x: 183
        'y': 260
      get_token:
        x: 34
        'y': 69
      get_start_time:
        x: 712
        'y': 422
      no_subscriptions:
        x: 374
        'y': 66
        navigate:
          e22ee3c8-ba93-dedc-2e35-75f740d8620a:
            targetId: 38c91957-d0b5-2079-7957-64c4177cf2bd
            port: 'TRUE'
      is_subscription_old:
        x: 602
        'y': 614
      note_failure:
        x: 282
        'y': 419
    results:
      FAILURE:
        11f6da47-2670-97a9-6960-bbb033d32578:
          x: 839
          'y': 65
      SUCCESS:
        38c91957-d0b5-2079-7957-64c4177cf2bd:
          x: 600
          'y': 65

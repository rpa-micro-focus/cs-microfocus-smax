########################################################################################################################
#!!
#! @description: Cancels all subscriptions that meet the filter criteria and are older than the given time limit (in millis). The subscriptions might have been created by any user.
#!
#! @input filter: Which services to cancel
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
    - filter: "RemoteServiceInstanceID!=null+and+(Status='Terminated'+or+Status='Active')"
    - time_limit: '90000000'
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.smax.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_time_now
    - get_subscriptions:
        do:
          io.cloudslang.microfocus.smax.subscription.get_subscriptions:
            - token: '${token}'
            - layout: 'Id,DisplayLabel,StartDate,Status,Subscriber,SubscribedToService,RemoteServiceInstanceID,InitiatedByOffering'
            - filter: "${filter+'+and+StartDate+lt+'+str(int(time_now)-int(time_limit))}"
        publish:
          - subscriptions_json
          - subscription_ids
        navigate:
          - FAILURE: on_failure
          - SUCCESS: no_subscriptions
    - get_time_now:
        do:
          io.cloudslang.base.datetime.get_millis: []
        publish:
          - time_now: '${time_millis}'
        navigate:
          - SUCCESS: get_subscriptions
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${subscription_ids}'
        publish:
          - subscription_id: '${result_string}'
        navigate:
          - HAS_MORE: get_subscriber_id
          - NO_MORE: has_failed
          - FAILURE: on_failure
    - cancel_subscription:
        do:
          io.cloudslang.microfocus.smax.subscription.cancel_subscription:
            - token: '${token}'
            - user_id: '${subscriber_id}'
            - subscription_id: '${subscription_id}'
            - description: "${'' if display_label is None else 'Cancel: '+display_label}"
            - display_label: "${'' if display_label is None else 'Cancel: '+display_label}"
            - offering_id: '${offering_id}'
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
          - 'FALSE': list_iterator
    - get_subscriber_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${subscriptions_json}'
            - json_path: "${\"$.entities[?(@.properties.Id == '%s')].properties.Subscriber\" % subscription_id}"
        publish:
          - subscriber_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_offering_id
          - FAILURE: note_failure
    - get_offering_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${subscriptions_json}'
            - json_path: "${\"$.entities[?(@.properties.Id == '%s')].properties.InitiatedByOffering\" % subscription_id}"
        publish:
          - offering_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_display_label
          - FAILURE: note_failure
    - get_display_label:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${subscriptions_json}'
            - json_path: "${\"$.entities[?(@.properties.Id == '%s')].properties.DisplayLabel\" % subscription_id}"
        publish:
          - display_label: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: cancel_subscription
          - FAILURE: cancel_subscription
  outputs:
    - cancel_failed: "${'' if len(cancel_failed) == 0 else cancel_failed[:-1]}"
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      has_failed:
        x: 715
        'y': 262
        navigate:
          99b3f49f-39b1-0d41-41a8-6da5f0a8658b:
            targetId: 11f6da47-2670-97a9-6960-bbb033d32578
            port: 'TRUE'
          c259dce9-dc88-d9a7-9356-e335a8a1dd85:
            targetId: 38c91957-d0b5-2079-7957-64c4177cf2bd
            port: 'FALSE'
      cancel_subscription:
        x: 230
        'y': 445
      get_subscriber_id:
        x: 718
        'y': 443
      get_offering_id:
        x: 646
        'y': 670
      get_time_now:
        x: 34
        'y': 259
      get_subscriptions:
        x: 219
        'y': 259
      get_display_label:
        x: 357
        'y': 670
      list_iterator:
        x: 485
        'y': 261
      get_token:
        x: 34
        'y': 69
      no_subscriptions:
        x: 219
        'y': 82
        navigate:
          e22ee3c8-ba93-dedc-2e35-75f740d8620a:
            targetId: 38c91957-d0b5-2079-7957-64c4177cf2bd
            port: 'TRUE'
      note_failure:
        x: 484
        'y': 479
    results:
      FAILURE:
        11f6da47-2670-97a9-6960-bbb033d32578:
          x: 711
          'y': 80
      SUCCESS:
        38c91957-d0b5-2079-7957-64c4177cf2bd:
          x: 486
          'y': 82

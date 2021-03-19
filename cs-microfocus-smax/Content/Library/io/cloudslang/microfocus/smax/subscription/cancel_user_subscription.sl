########################################################################################################################
#!!
#! @description: Cancels the given subscription belonging to the given user (must be the same as the one who has authenticated).
#!
#! @input user_id: ID of a user owning the subscription (and also authenticated user)
#! @input subscription_id: Subscription ID to be cancelled
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax.subscription
flow:
  name: cancel_user_subscription
  inputs:
    - token
    - user_id
    - subscription_id
  workflow:
    - smax_http_action:
        do:
          io.cloudslang.microfocus.smax._operations.smax_http_action:
            - url: "${'/rest/%s/ess/subscription/cancelSubscription/%s/%s' % (get_sp('io.cloudslang.microfocus.smax.smax_tenant_id'), user_id, subscription_id)}"
            - method: PUT
            - token: '${token}'
            - body: "${'{id: \"%s\", userId: \"%s\"}' % (subscription_id, user_id)}"
        publish:
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      smax_http_action:
        x: 73
        'y': 93
        navigate:
          628cc70a-9395-2ad6-9440-ef858b400d24:
            targetId: 7950213f-3eb5-a4c5-55aa-6183a1383a04
            port: SUCCESS
    results:
      SUCCESS:
        7950213f-3eb5-a4c5-55aa-6183a1383a04:
          x: 272
          'y': 93

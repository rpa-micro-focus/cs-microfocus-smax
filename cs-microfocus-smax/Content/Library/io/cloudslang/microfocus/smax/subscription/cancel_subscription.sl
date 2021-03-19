########################################################################################################################
#!!
#! @description: Cancels the given subscription (belonging to any user).
#!
#! @input user_id: ID of a user owning the subscription
#! @input subscription_id: Subscription ID to be cancelled
#! @input offering_id: ID of the Offering ID assigned to this subscription
#! @input display_label: Display label of the cancel request
#! @input description: Description of the cancel request
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax.subscription
flow:
  name: cancel_subscription
  inputs:
    - token
    - user_id
    - subscription_id
    - offering_id
    - display_label:
        required: false
    - description:
        required: false
  workflow:
    - create_entity:
        do:
          io.cloudslang.microfocus.smax.entity.create_entity:
            - token: '${token}'
            - entity_type: Request
            - entity_properties: "${'''\n{\n    \"SubscriptionActionType\": \"Cancel\",\n    \"DataDomains\": [\"Public\"],\n    \"Description\": \"%s\",\n    \"DisplayLabel\": \"%s\",\n    \"RegisteredForSubscription\": \"%s\",\n    \"RequestedByPerson\": \"%s\",\n    \"RequestedForPerson\": \"%s\",\n    \"RequestsOffering\": \"%s\"\n}\n''' % (\\\n    'Cancel: '+subscription_id if description is None else description,\\\n    'Cancel: '+subscription_id if display_label is None else display_label,\\\n    subscription_id,user_id,user_id, offering_id\n)}"
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - return_result: '${return_result}'
    - error_message: '${error_message}'
    - status_code: '${status_code}'
    - return_code: '${return_code}'
    - response_headers: '${response_headers}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_entity:
        x: 70
        'y': 111
        navigate:
          51c9b377-f938-e22f-2017-460fd72a9d5c:
            targetId: 7950213f-3eb5-a4c5-55aa-6183a1383a04
            port: SUCCESS
    results:
      SUCCESS:
        7950213f-3eb5-a4c5-55aa-6183a1383a04:
          x: 272
          'y': 112

########################################################################################################################
#!!
#! @description: Goes over the given components and gets values from the given properties and returns them as as or db providers.
#!               
#!
#! @input properties_mapping: 'as#azure#Microsoft Azure Server Template 18.4.1#primary_ip_address|as#aws#Amazon Server Template 18.3.0#primary_ip_address|db#azure#Microsoft Azure Server Template 18.4.1 - Postgres#primary_ip_address|db#aws#Amazon RDS Template 1.4.0#cloud_resource_identifier'
#! @input delimiter: Delimiter of values; first character delimits the various component records; the second character delimits the tokens within the component record
#!!#
########################################################################################################################
namespace: Integrations.microfocus.smax
flow:
  name: get_component_property_value
  inputs:
    - instance_id
    - properties_mapping
    - delimiter:
        default: '|#'
        private: true
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.smax.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_components
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${properties_mapping.strip()}'
            - separator: '${delimiter[0]}'
            - delimiter: '${delimiter[1]}'
        publish:
          - tier: "${'' if len(result_string) == 0 else result_string.split(delimiter)[0]}"
          - provider: "${'' if len(result_string) == 0 else result_string.split(delimiter)[1]}"
          - component_name: "${'' if len(result_string) == 0 else result_string.split(delimiter)[2]}"
          - property_name: "${'' if len(result_string) == 0 else result_string.split(delimiter)[3]}"
        navigate:
          - HAS_MORE: get_component_id
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_property_value:
        do:
          io.cloudslang.microfocus.dnd.property.get_property_value:
            - token: '${token}'
            - instance_id: '${instance_id}'
            - component_id: '${component_id}'
            - property_name: '${property_name}'
        publish:
          - property_value
        navigate:
          - SUCCESS: is_property_given
          - FAILURE: on_failure
    - get_components:
        do:
          io.cloudslang.microfocus.dnd.component.get_components:
            - token: '${token}'
            - instance_id: '${instance_id}'
        publish:
          - components_json
          - db_ip: ''
          - as_ip: ''
          - db_provider: ''
          - as_provider: ''
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - get_component_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${components_json}'
            - json_path: "${\"$.components.[?(@.displayName=='%s')].id\" % component_name}"
        publish:
          - component_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: is_component_present
          - FAILURE: on_failure
    - is_property_given:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(property_value) > 0)}'
        navigate:
          - 'TRUE': get_provider_ip
          - 'FALSE': list_iterator
    - get_provider_ip:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
            - tier: '${tier}'
            - provider: '${provider}'
            - property_value: '${property_value}'
            - db_ip: '${db_ip}'
            - as_ip: '${as_ip}'
            - db_provider: '${db_provider}'
            - as_provider: '${as_provider}'
        publish:
          - db_ip: "${property_value if tier == 'db' else db_ip}"
          - as_ip: "${property_value if tier == 'as' else as_ip}"
          - db_provider: "${provider if tier == 'db' else db_provider}"
          - as_provider: "${provider if tier == 'as' else as_provider}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - is_component_present:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(component_id) > 0)}'
        navigate:
          - 'TRUE': get_property_value
          - 'FALSE': list_iterator
  outputs:
    - db_ip: '${db_ip}'
    - as_ip: '${as_ip}'
    - db_provider: '${db_provider}'
    - as_provider: '${as_provider}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 40
        'y': 74
      list_iterator:
        x: 464
        'y': 69
        navigate:
          e2bbd5e9-daaa-f58a-6250-0a1215cadd48:
            targetId: e3ba52f6-6707-983d-5f1e-70bb84cfa5c7
            port: NO_MORE
      get_property_value:
        x: 464
        'y': 510
      get_components:
        x: 213
        'y': 69
      is_component_present:
        x: 621
        'y': 449
      is_property_given:
        x: 282
        'y': 455
      get_provider_ip:
        x: 219
        'y': 222
      get_component_id:
        x: 703
        'y': 226
    results:
      SUCCESS:
        e3ba52f6-6707-983d-5f1e-70bb84cfa5c7:
          x: 738
          'y': 67

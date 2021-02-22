########################################################################################################################
#!!
#! @system_property smax_url: SMAX URL; e.g. https://master.smax.swdemos.net
#! @system_property smax_tenant_id: SMAX tenant ID
#! @system_property smax_username: SMAX user name
#! @system_property smax_password: SMAX user password
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.smax
properties:
  - smax_url:
      value: ''
      sensitive: false
  - smax_tenant_id:
      value: ''
      sensitive: false
  - smax_username:
      value: ''
      sensitive: false
  - smax_password:
      value: ''
      sensitive: true
  - proxy_host: ''
  - proxy_port: '8080'
  - proxy_username: ''
  - proxy_password:
      value: ''
      sensitive: true

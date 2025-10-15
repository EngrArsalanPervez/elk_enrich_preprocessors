###
###
###
###
### Delete
###
###
###
###
DELETE /netstats
###
DELETE /_ingest/pipeline/combined_pipeline
###
DELETE /_enrich/policy/ip_mac
###
DELETE /_enrich/policy/dc_devices_os_ip
###
DELETE /_enrich/policy/dc_devices_big_data_ip
###
DELETE /_enrich/policy/site_devices
###
###
###
###
###
### Post
###
###
###
###
POST /netstats/_doc?refresh=true
{
    "src_mac": "00:90:0B:D8:6E:19",
    "vlan_id": 1,
    "last_seen": "2025-09-26T09:07:02Z",
    "dst_mac": "00:90:0B:D8:6D:71",
    "dst_ip": "192.168.115.3",
    "l4_proto": 6,
    "packets": 125,
    "src_ip": "10.130.21.1",
    "src_port": 20756,
    "bytes": 9602,
    "flow_id": "12159718995260649163",
    "dst_port": 44747,
    "fist_seen": "2025-09-26T09:07:02Z",
    "port_id": 1,
    "duration": 1
}
###
###
###
###
### Policies
###
###
###
###
###
PUT /_enrich/policy/ip_mac
{
  "match": {
    "indices": "ip_mac",
    "match_field": "IP",
    "enrich_fields": [ "S/N", "Dep", "SWITCH_NAME", "PORT", "Name", "IP", "GATEWAY", "mac" ]
  }
}
###
PUT /_enrich/policy/site_devices
{
  "match": {
    "indices": "site_devices",
    "match_field": "IP",
    "enrich_fields": [ "Operator", "Host_Name", "IP", "Site Category", "City", "Role", "Site_Name", "Region" ]
  }
}
###
PUT /_enrich/policy/dc_devices_os_ip
{
  "match": {
    "indices": "dc_devices",
    "match_field": "OS_IP",
    "enrich_fields": [ "OS_IP", "Device_Name", "Big_Data_IP", "Device_Type", "Rack_ID", "Server_Switch" ]
  }
}
###
PUT /_enrich/policy/dc_devices_big_data_ip
{
  "match": {
    "indices": "dc_devices",
    "match_field": "Big_Data_IP",
    "enrich_fields": [ "OS_IP", "Device_Name", "Big_Data_IP", "Device_Type", "Rack_ID", "Server_Switch" ]
  }
}
###
###
### Execute Policies
###
###
###
###
###
POST /_enrich/policy/ip_mac/_execute
###
POST /_enrich/policy/site_devices/_execute
###
POST /_enrich/policy/dc_devices_os_ip/_execute
###
POST /_enrich/policy/dc_devices_big_data_ip/_execute
###
###
###
###
### Pipelines
###
###
###
###
PUT /_ingest/pipeline/combined_pipeline
{
  "processors": [
    {
      "enrich": {
        "policy_name": "ip_mac",
        "field": "src_ip",
        "target_field": "enriched_src_ip_to_ip_mac",
        "max_matches": 1
      }
    },
    {
      "enrich": {
        "policy_name": "ip_mac",
        "field": "dst_ip",
        "target_field": "enriched_dst_ip_to_ip_mac",
        "max_matches": 1
      }
    },
    {
      "enrich": {
        "policy_name": "site_devices",
        "field": "src_ip",
        "target_field": "enriched_src_ip_to_site_devices",
        "max_matches": 1
      }
    },
    {
      "enrich": {
        "policy_name": "site_devices",
        "field": "dst_ip",
        "target_field": "enriched_dst_ip_to_site_devices",
        "max_matches": 1
      }
    },
    {
      "enrich": {
        "policy_name": "dc_devices_os_ip",
        "field": "src_ip",
        "target_field": "enriched_src_ip_to_dc_devices_os_ip",
        "max_matches": 1
      }
    },
    {
      "enrich": {
        "policy_name": "dc_devices_os_ip",
        "field": "dst_ip",
        "target_field": "enriched_dst_ip_to_dc_devices_os_ip",
        "max_matches": 1
      }
    },
    {
      "enrich": {
        "policy_name": "dc_devices_big_data_ip",
        "field": "src_ip",
        "target_field": "enriched_src_ip_to_dc_devices_big_data_ip",
        "max_matches": 1
      }
    },
    {
      "enrich": {
        "policy_name": "dc_devices_big_data_ip",
        "field": "dst_ip",
        "target_field": "enriched_dst_ip_to_dc_devices_big_data_ip",
        "max_matches": 1
      }
    }
  ]
}
###
###
###
###
### Execute Pipelines
###
###
###
###
PUT /netstats/_settings
{
  "index.default_pipeline": "combined_pipeline"
}
###
###
###
###
### GET
###
###
###
###
GET /_ingest/pipeline
###
GET /_enrich/policy
###
###
###
###
###
### Post
###
###
###
###
POST /netstats/_doc?refresh=true
{
    "src_mac": "00:90:0B:D8:6E:19",
    "vlan_id": 1,
    "last_seen": "2025-09-26T09:07:02Z",
    "dst_mac": "00:90:0B:D8:6D:71",
    "dst_ip": "172.16.6.202",
    "l4_proto": 6,
    "packets": 125,
    "src_ip": "10.130.21.1",
    "src_port": 20756,
    "bytes": 9602,
    "flow_id": "12159718995260649163",
    "dst_port": 44747,
    "fist_seen": "2025-09-26T09:07:02Z",
    "port_id": 1,
    "duration": 0
}

###

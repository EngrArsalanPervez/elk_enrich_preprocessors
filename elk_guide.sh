######################################Environment######################################
# 1 Time Offline Mapping Record
Index: ip_mac
Matching field: IP
Extract fields: Name
========================
|   Name |     IP      |
=======================
| Usman  | 192.168.0.1 |
| Fawad  | 192.168.0.1 |
========================


# 24/7 Updating Records Table
Index: netstats
Matching field: src_ip
Bring Name from Mapping Table (ip_mac)
{
    "src_mac": "00:90:0B:D8:6E:19",
    "vlan_id": 1,
    "last_seen": "2025-09-26T09:07:02Z",
    "dst_mac": "00:90:0B:D8:6D:71",
    "dst_ip": "192.168.115.3",
    "l4_proto": 6,
    "packets": 125,
    "src_ip": "192.168.115.2",
    "src_port": 20756,
    "bytes": 9602,
    "flow_id": "12159718995260649163",
    "dst_port": 44747,
    "fist_seen": "2025-09-26T09:07:02Z",
    "port_id": 1
}



######################################Delete Old######################################
# Delete Index
DELETE /netstats

# List Pipelines
GET /_ingest/pipeline

# Delete all ingest pipelines
DELETE /_ingest/pipeline/<pipeline-name>

# List Enrich Policies
GET /_enrich/policy

# Delete all enrich policies
POST /_enrich/policy/<policy_name>/_stop
DELETE /_enrich/policy/<policy_name>



######################################Create Index######################################
POST /netstats/_doc?refresh=true
{
    "src_mac": "00:90:0B:D8:6E:19",
    "vlan_id": 1,
    "last_seen": "2025-09-26T09:07:02Z",
    "dst_mac": "00:90:0B:D8:6D:71",
    "dst_ip": "192.168.115.3",
    "l4_proto": 6,
    "packets": 125,
    "src_ip": "10.130.21.1/24",
    "src_port": 20756,
    "bytes": 9602,
    "flow_id": "12159718995260649163",
    "dst_port": 44747,
    "fist_seen": "2025-09-26T09:07:02Z",
    "port_id": 1
}

######################################Enrich Policy######################################
# MAP Records => ip_mac
# Matching Field = IP
# What to extract = [ "Name" ]

PUT /_enrich/policy/ip-to-name-policy
{
  "match": {
    "indices": "ip_mac", # MAP Records Table
    "match_field": "IP", # Lookup Attribute
    "enrich_fields": [ "Name" ] # Pick listed info
  }
}

# Execute
POST /_enrich/policy/ip-to-name-policy/_execute


######################################Ingest Pipeline######################################
PUT /_ingest/pipeline/enrich-ip-name
{
  "processors": [
    {
      "enrich": {
        "policy_name": "ip-to-name-policy",
        "field": "src_ip",
        "target_field": "enriched_src_ip",
        "max_matches": 1
      }
    }
  ]
}

######################################Apply Pipeline######################################
PUT /netstats/_settings
{
  "index.default_pipeline": "enrich-ip-name"
}

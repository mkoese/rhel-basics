# Download file
curl -kL http://speedtest.tele2.net/10GB.zip -o /dev/null

# curl with jq
#  "syncToken": "1586547791",
#  "createDate": "2020-04-10-19-43-11",
#  "prefixes": [
#    {
#      "ip_prefix": "13.248.118.0/24",
#      "region": "eu-west-1",
#      "service": "AMAZON",
#      "network_border_group": "eu-west-1"
#    },
#    {
#      "ip_prefix": "18.208.0.0/13",
#      "region": "us-east-1",
#      "service": "AMAZON",
#      "network_border_group": "us-east-1"
#    },

curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.service=="S3") | .ip_prefix'

curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.region=="us-east-1") | select(.service=="S3") | .ip_prefix'
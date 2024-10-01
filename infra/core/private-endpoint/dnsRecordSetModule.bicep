param dnsZoneName string
param recordSetName string
param ttl int = 3600
param ipAddresses array
param location string 

resource privatednszone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: dnsZoneName
}

resource dnsRecordSet 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: recordSetName
  parent: privatednszone
  properties: {
    ttl: ttl
    aRecords: [
      for ip in ipAddresses: {
        ipv4Address: ip
      }
    ] 
  }
}

output ipAddressesDebug array = ipAddresses
output aRecordsDebug array = [
  for ip in ipAddresses: {
    ipv4Address: ip
  }
]

output recordSetId string = dnsRecordSet.id

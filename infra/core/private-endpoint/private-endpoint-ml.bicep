//resource detail
param name string
param resourceId string
param resourceEndpointType string
param location string
param subnetId string
param privateDnsZoneName string
param nootebookPrivateDnsZoneName string
param dnsZoneResourceGroup string


resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
  scope: resourceGroup(dnsZoneResourceGroup)
}

resource nbPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: nootebookPrivateDnsZoneName
  scope: resourceGroup(dnsZoneResourceGroup)
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: name
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: name
        properties: {
          privateLinkServiceId: resourceId
          groupIds: [
            resourceEndpointType
          ]
        }
      }
    ]
  }
}

resource pvtEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
      {
        name: 'config2'
        properties: {
          privateDnsZoneId: nbPrivateDnsZone.id
        }
      }
    ]

  }
}

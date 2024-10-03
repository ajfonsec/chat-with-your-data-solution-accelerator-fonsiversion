//resource detail
param name string
param resourceId string
param resourceEndpointType string
param location string
param subnetId string
param privateDnsZoneName string
param dnsZoneResourceGroup string
param privateEndpointRG string


resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
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
    ]
  }
}




// Try to access the existing private endpoint from here 

resource existingkeyvault 'Microsoft.Network/privateEndpoints@2020-06-01' existing = {
  name: privateEndpoint.name
  scope: resourceGroup(privateEndpointRG)
}

output ipaddress string = reference(existingkeyvault.id, '2021-08-01').networkInterfaces[0].ipConfigurations[0].properties.privateIPAddress

// reference(resourceId('Microsoft.Network/networkInterfaces', parameters('nicName')), '2021-08-01').ipConfigurations[0].properties.privateIPAddress]

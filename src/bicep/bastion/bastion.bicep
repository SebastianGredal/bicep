targetScope = 'resourceGroup'

metadata name = 'Bastion Module '
metadata description = 'Module to deploy Azure Bastion Host'

// ----------
// PARAMETERS
// ----------
@sys.description('Prefix for all resources')
param parPrefix string = 'anq'

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

@sys.description('The name of the Virtual Network.')
param parVirtualNetworkName string = '${parPrefix}-vnet-bastion-${parLocation}'

@sys.description('The address prefix of the Virtual Network.')
param parAddressPrefix string

@sys.description('The name of the Bastion Host.')
param parBastionName string = '${parPrefix}bastion${parLocation}'

@sys.description('The SKU of the Bastion Host.')
@allowed([
  'Basic'
  'Standard'
])
param parBastionSku string = 'Standard'

@sys.description('The Scale Units of the Bastion Host. Minimum value of 2 for Standard SKU.')
param parScaleUnits int = 2

@sys.description('Public IP Address SKU.')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIpSku string = 'Standard'

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------
resource resVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: parVirtualNetworkName
  location: parLocation
  tags: parTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        parAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: parAddressPrefix
        }
      }
    ]
  }
  resource resAzureBastionSubnet 'subnets' existing = {
    name: 'AzureBastionSubnet'
  }
}

resource resBastion 'Microsoft.Network/bastionHosts@2023-04-01' = {
  name: parBastionName
  location: parLocation
  sku: {
    name: parBastionSku
  }
  tags: parTags
  properties: {
    enableIpConnect: true
    enableFileCopy: true
    enableTunneling: true
    scaleUnits: parScaleUnits
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resVnet::resAzureBastionSubnet.id
          }
          publicIPAddress: {
            id: modPublicIp.outputs.outPublicIpId
          }
        }
      }
    ]
  }
}

module modPublicIp '../public-ip/public-ip.bicep' = {
  name: 'public-ip'
  params: {
    parPublicIpName: parBastionName
    parLocation: parLocation
    parAvailabilityZones: []
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: parPublicIpSku
    }
    parTags: parTags
  }
}

// ----------
//  OUTPUTS
// ----------
output outBastionId string = resBastion.id
output outBastionName string = resBastion.name
output outVirtualNetworkId string = resVnet.id
output outVirtualNetworkName string = resVnet.name
output outSubnetId string = resVnet::resAzureBastionSubnet.id

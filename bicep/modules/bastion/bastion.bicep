targetScope = 'resourceGroup'

metadata name = 'Bastion Module '
metadata description = 'Module to deploy Azure Bastion Host'

// ----------
// PARAMETERS
// ----------
@sys.description('Prefix for all resources')
param parPrefix string = 'alz'

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

var varPublicIpTags = union(parTags, {
    'resource-usage': 'azure-bastion'
  })

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
          networkSecurityGroup: {
            id: resNetworkSecurityGroup.id
          }
        }
      }
    ]
  }
  resource resAzureBastionSubnet 'subnets' existing = {
    name: 'AzureBastionSubnet'
  }
}

resource resNetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: '${parVirtualNetworkName}-nsg'
  location: parLocation
  tags: parTags
  properties: {
    securityRules: [
      {
        name: 'AllowHttpsInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          direction: 'Inbound'
          priority: 100
          protocol: 'TCP'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          direction: 'Inbound'
          priority: 110
          protocol: 'TCP'
          sourceAddressPrefix: 'GatewayManager'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '5701'
            '8080'
          ]
          direction: 'Inbound'
          priority: 120
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          direction: 'Inbound'
          priority: 4095
          protocol: 'TCP'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 4096
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowSshRDPOutbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          direction: 'Outbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'AzureCloud'
          destinationPortRange: '443'
          direction: 'Outbound'
          priority: 110
          protocol: 'TCP'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowBastionCommunication'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '5701'
            '8080'
          ]
          direction: 'Outbound'
          priority: 120
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowHttpOutbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'Internet'
          destinationPortRange: '80'
          direction: 'Outbound'
          priority: 130
          protocol: 'TCP'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 140
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
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
    parTags: varPublicIpTags
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

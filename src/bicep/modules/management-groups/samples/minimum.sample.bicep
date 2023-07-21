//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'tenant'

// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum '../management-groups.bicep' = {
  name: 'minimum'
  params: {}
}

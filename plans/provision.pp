# Provisions and configures a VM with Generic Cloud Service.
#
# @param image
#   The image to use.
# @param name
#   The name to give the VM.
# @param region
#   The region to provision the VM in.
# @param size
#   The size of the VM.
#
plan boltspec::provision (
  Enum['Debian10', 'Ubuntu2004'] $image  = 'Ubuntu2004',
  Enum['eastus', 'westus']       $region = 'eastus',
  Enum['D1', 'D2', 'D3']         $size   = 'D1',
  String                         $name
) {
  $request_uri = "https://api.gcs.com/v1/${lookup('boltspec::subscription_id')}/${region}/vms"

  $params = {
    'base_url'      => $request_uri,
    'method'        => 'put',
    'json_endpoint' => true,
    'headers'       => {
      'Authorization' => "Bearer ${lookup('boltspec::bearer_token')}"
    },
    'body'          => {
      'properties' => {
        'image' => $image,
        'name'  => $name,
        'size'  => $size
      }
    }
  }

  $provision_result = run_task('http_request', 'localhost', $params)

  $configure_result = run_task('boltspec::configure', $provision_result[0]['host'])

  return $configure_result
}

# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

describe 'boltspec::provision' do
  let(:hiera_data) { YAML.load_file(File.expand_path('../../data/data.yaml', __dir__)) }
  let(:image)      { 'Ubuntu2004' }
  let(:name)       { 'linux' }
  let(:plan)       { 'boltspec::provision' }
  let(:region)     { 'eastus' }
  let(:size)       { 'D1' }

  it 'correctly formats the request' do
    allow_task('boltspec::configure')

    expected_params = {
      'base_url'         => "https://api.gcs.com/v1/#{hiera_data['boltspec::subscription_id']}/#{region}/vms",
      'method'           => 'put',
      'json_endpoint'    => true,
      'follow_redirects' => true,
      'max_redirects'    => 20,
      'headers'          => {
        'Authorization' => "Bearer #{hiera_data['boltspec::bearer_token']}"
      },
      'body'             => {
        'properties' => {
          'image' => image,
          'name'  => name,
          'size'  => size
        }
      }
    }

    expect_task('http_request').with_targets(['localhost'])
                               .with_params(expected_params)

    run_plan(plan, 'image' => image, 'name' => name, 'region' => region, 'size' => size)
  end

  it 'configures the returned host' do
    allow_task('http_request').always_return({ 'host' => name })

    expect_task('boltspec::configure').with_targets([name])

    run_plan(plan, 'image' => image, 'name' => name, 'region' => region, 'size' => size)
  end
end

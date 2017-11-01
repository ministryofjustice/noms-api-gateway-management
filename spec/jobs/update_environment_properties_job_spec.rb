require 'rails_helper'

RSpec.describe UpdateEnvironmentPropertiesJob, type: :job do

  let(:client) do
    double 'NomisApiClient',
    get_health: 'updated',
    get_version: '1.0.1',
    get_version_timestamp: '2017-09-14 09:56:36'
  end

  let(:environment) do
    create(
      :environment,
      health: 'stale',
      deployed_version: '0.0.0',
      deployed_version_timestamp: Time.now
    )
  end

  subject { UpdateEnvironmentPropertiesJob.new(environment) }

  before do
    Delayed::Worker.delay_jobs = false
    allow(NomisApiClient).to receive(:new).and_return(client)
  end

  it 'sets #health' do
    subject.perform_now
    expect(environment.health).to eq 'updated'
  end

  it 'sets #deployed_version' do
    subject.perform_now
    expect(environment.deployed_version).to eq '1.0.1'
  end

  it 'sets #deployed_version_timestamp' do
    subject.perform_now
    expect(environment.deployed_version_timestamp.to_s).to eq '2017-09-14 09:56:36 +0100'
  end
end

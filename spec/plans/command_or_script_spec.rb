# frozen_string_literal: true

require 'spec_helper'

describe 'boltspec::command_or_script' do
  let(:command) { 'whoami' }
  let(:plan)    { 'boltspec::command_or_script' }
  let(:script)  { 'boltspec/script.rb' }
  let(:targets) { 'localhost' }

  it 'fails if neither command nor script are specified' do
    result = run_plan(plan, 'targets' => targets)

    expect(result.ok?).to be(false)
    expect(result.value.msg).to match(/Must specify either command or script/)
  end

  it 'fails if both command and script are specified' do
    result = run_plan(plan, 'command' => command, 'script' => script, 'targets' => targets)

    expect(result.ok?).to be(false)
    expect(result.value.msg).to match(/Cannot specify both command and script/)
  end

  it 'runs the specified command on the targets and returns a value' do
    expect_command(command).with_targets(targets).always_return('stdout' => 'localhost')

    result = run_plan(plan, 'command' => command, 'targets' => targets)

    expect(result.ok?).to be(true)
    expect(result.value.first['stdout']).to match(/localhost/)
  end

  it 'runs the specified script on the targets and returns a value' do
    expect_script(script).with_targets(targets).always_return('stdout' => 'success')

    result = run_plan(plan, 'script' => script, 'targets' => targets)

    expect(result.ok?).to be(true)
    expect(result.value.first['stdout']).to match(/success/)
  end
end

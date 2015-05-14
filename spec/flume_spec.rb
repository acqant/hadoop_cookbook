require 'spec_helper'

describe 'hadoop::flume' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        node.default['flume']['flume_conf']['key'] = 'value'
      end.converge(described_recipe)
    end
    conf_dir = '/etc/flume/conf.chef'

    it 'installs flume package' do
      expect(chef_run).to install_package('flume')
    end

    it "creates #{conf_dir} directory" do
      expect(chef_run).to create_directory(conf_dir)
    end

    it "creates #{conf_dir}/flume.conf from template" do
      expect(chef_run).to create_template("#{conf_dir}/flume.conf")
    end
  end

  context 'using CDH' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        node.override['hadoop']['distribution'] = 'cdh'
      end.converge(described_recipe)
    end

    it 'install flume-ng package' do
      expect(chef_run).to install_package('flume-ng')
    end
  end
end

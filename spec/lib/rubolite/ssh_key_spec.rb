require "spec_helper"

describe Rubolite::SSHKey do
  context "from a file" do
    it "generates an ssh key from a file" do
      ssh_key = Rubolite::SSHKey.from_file("./spec/fixtures/example.pub")

      # Yes this should be 3 separate tests but it's ok, we'll live.
      expect(ssh_key.type).to eq("ssh-rsa")
      expect(ssh_key.key).to eq("AAAAB3NzaC1yc2EAAAADAQABAAABAQC/Zkiw2QoYtekwZUYULwQsrPJubWafiuewoP03DRn3xjwoNo0q7FE0nIw2ENODiaM8KD0+L+ax0UCdNcCiJYuzouHENBvXYxsWSk5sZicRWINJ91Jd6KZnMvCr06oObNnJKdE+7UxeC06512nBREW7xHc4urHSiBoejx8fJOUraI6Y0t+Y7l4EiugTUcZLdN3b4YNksQvv16GDnreS+0SkZKcU5zj8pIE3DRBvs8MeuK5N1oQQNkbLXLbTtBqTPfiQz7Ikj8YFaBBX8rXd66yu0sMjGImxWZjBNGPscvch/G5MGSabpRSZALWi+uN67CxJcj3vZPg6mJSxnpsXxOdZ")
      expect(ssh_key.comment).to eq("robertross@paperwalls.local")
    end
  end

  context "from a string" do
    it "generates an ssh key from a string" do
      ssh_key = Rubolite::SSHKey.from_string("ssh-rsa somekeyfingerprint comment")
      expect(ssh_key.type).to eq("ssh-rsa")
      expect(ssh_key.key).to eq("somekeyfingerprint")
      expect(ssh_key.comment).to eq("comment")
    end
  end

  context "saving", fake_fs: true do
    subject { Rubolite::SSHKey.from_string("ssh-rsa awesomekeyprint robertross@local") }

    before(:each) { FileUtils.mkdir_p("./spec/fixtures") }

    it "saves a public key for a username to a path" do
      subject.write_for "kermit", "./spec/fixtures"
      expect(File.exists?("./spec/fixtures/kermit.pub")).to be_true
    end
  end
end
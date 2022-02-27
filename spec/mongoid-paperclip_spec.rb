require 'spec_helper'

RSpec.describe Mongoid::Paperclip, type: :unit do
  describe "avatar" do
    let(:user) { User.create }

    before do
      user.update avatar: File.new('spec/support/avatar.png', 'rb')
    end

    it "stores file_name" do
      expect(user.avatar_file_name).to eq("avatar.png")
    end

    it "stores content_type" do
      expect(user.avatar_content_type).to eq("image/png")
    end

    it "stores file_size" do
      expect(user.avatar_file_size).to eq(357)
    end

    it "stores updated_at" do
      expect(user.avatar_updated_at).to be_present
    end

    it "stores fingerprint" do
      expect(user.avatar_fingerprint).to eq("2584a801e588b3fcf4aa074efff77e30")
    end

    it "interpolates path and url properly" do
      id_partition = user.id.to_s.scan(/.{4}/).join("/")
      expect(user.avatar.url).to eq("/system/users/#{id_partition}/avatar-original.png?#{Time.now.to_i}")
      expect(user.avatar.path).to eq("#{__dir__}/public/system/users/#{id_partition}/avatar-original.png")
    end
  end

  describe "multiple attachments" do
    let(:user) { MultipleAttachments.create }

    it "works" do
      user.update avatar: File.new('spec/support/avatar.png', 'rb'), icon: File.new('spec/support/avatar.png', 'rb')
      expect(user.avatar_file_name).to eq("avatar.png")
      expect(user.icon_file_name).to eq("avatar.png")
    end
  end

  describe "disable fingerprint" do
    let(:user) { NoFingerprint.create }

    before do
      user.update avatar: File.new('spec/support/avatar.png', 'rb')
    end

    it "does not store a fingerprint" do
      expect(user.attributes).to_not include('fingerprint')
    end
  end
end

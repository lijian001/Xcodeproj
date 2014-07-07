require File.expand_path('../spec_helper', __FILE__)

module ProjectHelperSpecs
  describe Xcodeproj::Project::ProjectHelper do

    def subject
      Xcodeproj::Project::ProjectHelper
    end

    shared 'configuration settings' do
      extend SpecHelper::ProjectHelper
      built_settings = subject.common_build_settings(configuration, platform, nil, product_type, (language rescue nil))
      compare_settings(built_settings, fixture_settings[configuration])
    end

    shared 'target settings' do
      describe "in base configuration" do
        define configuration: :base
        behaves_like 'configuration settings'
      end

      describe "in Debug configuration" do
        define configuration: :debug
        behaves_like 'configuration settings'
      end

      describe "in Release configuration" do
        define configuration: :release
        behaves_like 'configuration settings'
      end
    end

    def target_from_fixtures(path)
      shared path do
        extend SpecHelper::ProjectHelper

        @path = path
        def self.fixture_settings
          Hash[[:base, :debug, :release].map { |c| [c, load_settings(@path, c)] }]
        end

        behaves_like 'target settings'
      end

      return path
    end

    describe '::common_build_settings' do

      describe "on platform OSX" do
        define platform: :osx

        describe "for product type bundle" do
          define product_type: :bundle
          behaves_like target_from_fixtures 'OSX_Bundle'
        end

        describe "in language Objective-C" do
          define language: :objc

          describe "for product type Dynamic Library" do
            define product_type: :dynamic_library
            behaves_like target_from_fixtures 'Objc_OSX_DynamicLibrary'
          end

          describe "for product type Framework" do
            define product_type: :framework
            behaves_like target_from_fixtures 'Objc_OSX_Framework'
          end

          describe "for product type Application" do
            define product_type: :application
            behaves_like target_from_fixtures 'Objc_OSX_Native'
          end

          describe "for product type Static Library" do
            define product_type: :static_library
            behaves_like target_from_fixtures 'Objc_OSX_StaticLibrary'
          end
        end

        describe "in language Swift" do
          define language: :swift

          describe "for product type Framework" do
            define product_type: :framework
            behaves_like target_from_fixtures 'Swift_OSX_Framework'
          end

          describe "for product type Application" do
            define product_type: :application
            behaves_like target_from_fixtures 'Swift_OSX_Native'
          end
        end
      end

      describe "on platform iOS" do
        define platform: :ios

        # TODO: Create a target and dump its config
        #describe "for product type Bundle" do
        #  define product_type: :bundle
        #  behaves_like target_from_fixtures 'iOS_Bundle'
        #end

        describe "in language Objective-C" do
          define language: :objc

          describe "for product type Framework" do
            define product_type: :framework
            behaves_like target_from_fixtures 'Objc_iOS_Framework'
          end

          describe "for product type Application" do
            define product_type: :application
            behaves_like target_from_fixtures 'Objc_iOS_Native'
          end

          describe "for product type Static Library" do
            define product_type: :static_library
            behaves_like target_from_fixtures 'Objc_iOS_StaticLibrary'
          end
        end

        describe "in language Swift" do
          define language: :swift

          describe "for product type Framework" do
            define product_type: :framework
            behaves_like target_from_fixtures 'Swift_iOS_Framework'
          end

          describe "for product type Application" do
            define product_type: :application
            behaves_like target_from_fixtures 'Swift_iOS_Native'
          end
        end

      end

    end
  end
end
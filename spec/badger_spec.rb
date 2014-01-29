require 'spec_helper'

module Badger
  describe Badger do
    before :each do
      @badger = Badger.new "https://github.com/doge/wow.git"
    end

    context 'should extract the user and repo' do
      it 'for a https url' do
        @badger.github_slug('https://github.com/doge/wow.git').should eql('doge/wow')
      end

      it 'for an ssh url' do
        @badger.github_slug('git@github.com:doge/wow.git').should eql('doge/wow')
      end
    end

    it 'should generate a badge list' do
      @badger.badge[0].should == "[![Build Status](http://img.shields.io/travis/doge/wow.svg)](https://travis-ci.org/doge/wow)"
      @badger.badge[1].should == "[![Coverage Status](http://img.shields.io/coveralls/doge/wow.svg)](https://coveralls.io/r/doge/wow)"
      @badger.badge[2].should == "[![Dependency Status](http://img.shields.io/gemnasium/doge/wow.svg)](https://gemnasium.com/doge/wow)"
      @badger.badge[3].should == "[![Code Climate](http://img.shields.io/codeclimate/github/doge/wow.svg)](https://codeclimate.com/github/doge/wow)"
    end

    context 'not' do
      it 'should remove a specified service' do
        @badger.remove 'travis'
        @badger.badge[0].should == "[![Coverage Status](http://img.shields.io/coveralls/doge/wow.svg)](https://coveralls.io/r/doge/wow)"
        @badger.badge[1].should == "[![Dependency Status](http://img.shields.io/gemnasium/doge/wow.svg)](https://gemnasium.com/doge/wow)"
        @badger.badge[2].should == "[![Code Climate](http://img.shields.io/codeclimate/github/doge/wow.svg)](https://codeclimate.com/github/doge/wow)"
      end

      it 'should remove specified services' do
        @badger.remove ['travis', 'gemnasium']
        @badger.badge[0].should == "[![Coverage Status](http://img.shields.io/coveralls/doge/wow.svg)](https://coveralls.io/r/doge/wow)"
        @badger.badge[1].should == "[![Code Climate](http://img.shields.io/codeclimate/github/doge/wow.svg)](https://codeclimate.com/github/doge/wow)"
        @badger.badge.length.should == 2
      end
    end

    context 'only' do
      it 'should have just the specified service' do
        @badger.only 'codeclimate'
        @badger.badge[0].should == "[![Code Climate](http://img.shields.io/codeclimate/github/doge/wow.svg)](https://codeclimate.com/github/doge/wow)"
        @badger.badge.length.should == 1
      end
    end

    context 'also' do
      it 'should generate an extra badge' do
        @badger.also 'mit'
        @badger.badge[4].should == "[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)"
      end
    end

    context 'gemspec' do
      it 'should generate badges based on gemspec' do
        @badger.gemspec [
                            "spec.name    'suchgem'",
                            "spec.license 'MIT'"
                        ]
        @badger.badge[4].should == "[![Gem Version](http://img.shields.io/gem/v/suchgem.svg)](https://rubygems.org/gems/suchgem)"
        @badger.badge[5].should == "[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)"
      end
    end
  end
end
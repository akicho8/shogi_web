#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

QueryInfo.parse("foo:>=").lookup_one(:foo)   # => ">="
QueryInfo.parse("foo:>=-1").lookup_one(:foo) # => {:operator=>:gteq, :value=>-1}
QueryInfo.parse("foo:>=1").lookup_one(:foo)  # => {:operator=>:gteq, :value=>1}
QueryInfo.parse("foo:>").lookup_one(:foo)    # => ">"
QueryInfo.parse("foo:>-1").lookup_one(:foo)  # => {:operator=>:gt, :value=>-1}
QueryInfo.parse("foo:>1").lookup_one(:foo)   # => {:operator=>:gt, :value=>1}
QueryInfo.parse("foo:=").lookup_one(:foo)    # => "="
QueryInfo.parse("foo:==1").lookup_one(:foo)  # => {:operator=>:eq, :value=>1}

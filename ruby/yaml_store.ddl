metadata    :name        => "Yaml Store",
			:description => "A conduit to search your puppet master's YAML store", 
			:author      => "Gary Larizza <glarizza@me.com>",
			:license     => "Apache License, Version 2.0",
			:version     => "1.0",
			:url         => "http://glarizza.posterous.com",
			:timeout     => 60

action "search", :description => "Retrieves Facter facts for specified nodes" do
    display :always

    input :hostname, 
          :prompt      => "Hostname",
          :description => "The hostname of the node for which we're getting facts",
          :type        => :string,
          :optional    => true,
		  :validation  => '(.*?)',
          :maxlength   => 230

	input :certname, 
          :prompt      => "The Puppet Certname Variable",
          :description => "The certname of the node for which we're getting facts",
          :type        => :string,
          :optional    => true,
		  :validation  => '(.*?)',
          :maxlength   => 230

	input :fact, 
          :prompt      => "A Searchable Facter Fact",
          :description => "The facter fact for which we want a value",
          :type        => :string,
          :optional    => true,
 	      :validation  => '(.*?)',
          :maxlength   => 230

    output :facts,
          :description => "The Facter facts you want displayed",
          :display_as  => "Fact Information"
end

module MCollective
    module Agent
        class Yaml_store<RPC::Agent
              require 'puppet'
              
              metadata    :name        => "yaml_store.rb",
                          :description => "A conduit to search your puppet master's YAML store.", 
                          :author      => "Gary Larizza <glarizza@me.com>",
                          :license     => "Apache License, Version 2.0",
                          :version     => "1.0",
                          :url         => "http://glarizza.posterous.com",
                          :timeout     => 3
              
              # Search action:  This action will check for the YAML file of a specified certname or hostname.
              # =>               If the file exists, it will output the contents of the YAML file. If it
              # =>               doesn't exist, you will receive an error message.
              # Variables:
              # =>              fact  => The fact for which we're checking a value
              # =>              value => The value for which we're searching
              # Calling:
              # =>              Run the fact with 'mc-rpc --agent yaml_store --action search --arg hostname=lab01-hsimaclab-hhs -v'
              # =>               or with 'mc-rpc --agent yaml_store --action search --arg certname=lab01-hsimaclab-hhs -v'  
              # =>               or with 'mc-rpc --agent yaml_store --action search --arg certname=lab01-hsimaclab-hhs --arg fact=warranty_end -v'     
              # 
        
              action "search" do
                
                if request.include?(:hostname) 
                  if request.include?(:fact)
                    searchfield = 'hostname'
                    arg = request[:hostname]
                    reply[:facts] = get_specific_fact(searchfield, arg, request[:fact])
                  else 
                    searchfield = 'hostname'
                    arg = request[:hostname]
                    reply[:facts] = get_all_facts(searchfield, arg)
                  end
                elsif request.include?(:certname)
                  if request.include?(:fact)
                    searchfield = 'certname'
                    arg = request[:certname]
                    reply[:facts] = get_specific_fact(searchfield, arg, request[:fact])
                  else 
                    searchfield = 'certname'
                    arg = request[:certname]
                    reply[:facts] = get_all_facts(searchfield, arg)
                  end
                end
    
              end # Action end
                   
                def get_all_facts(searchfield, arg)
                  Dir.glob("#{Puppet[:vardir]}/yaml/facts/*") {|file|
                    $tempfile = YAML::load_file(file).values
                    if $tempfile[searchfield] == arg
                      $found_file = true
                      break
                    end
                  }
                  
                  if $found_file
                    $tempfile.each_pair{|key, value|
                      puts "#{key} = #{value}"
                    }
                  else
                    puts "That #{searchfield} was not found."
                  end
                  
                end # Def end
                
                def get_specific_fact(searchfield, arg, thefact)
                  Dir.glob("#{Puppet[:vardir]}/yaml/facts/*") {|file|
                    $tempfile = YAML::load_file(file).values
                    if $tempfile[searchfield] == arg
                      $found_file = true
                      break
                    end
                  }
                  
                  if $found_file
                    if $tempfile[thefact]
                      puts "#{thefact} = #{$tempfile[thefact]}"
                    else
                      puts "#{thefact} is not a valid fact, or wasn't found."
                    end
                  else
                    puts "That #{searchfield} was not found."
                  end
                  
                end # Def end
                
        end # Class Etc_facts end
        
  end # Module Agent end
  
end # Module MCollective end
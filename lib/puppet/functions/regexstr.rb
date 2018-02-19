 Puppet::Functions.create_function(:'regexstr') do
#   dispatch :up do
#       param 'String', :some_string
#         end

    def regexstr(str)
      Regexp.new(Regexp.escape(str))
        end
     end

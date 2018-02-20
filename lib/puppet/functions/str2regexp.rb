 Puppet::Functions.create_function(:'str2regexp') do
#   dispatch :up do
#       param 'String', :some_string
#         end

    def str2regexp(str)
  #    Regexp.new(Regexp.escape(str))
      Regexp.escape(str)
       end
     end

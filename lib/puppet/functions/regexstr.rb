 Puppet::Functions.create_function(:'regexstr') do
#   dispatch :up do
#       param 'String', :some_string
#         end

    def regexstr(str)
      r=Regexp.new(Regexp.escape(str))
      r.gsub('\\','')
       end
     end

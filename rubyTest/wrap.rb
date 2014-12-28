#!/usr/bin/env ruby

def wrap(content)
  content.split.map{ |s| wrap_long_string(s) }.join(' ')
end


def wrap_long_string(text, max_width = 30)
  zero_width_space = "&#8203;"
  regex = /.{1,#{max_width}}/
  (text.length < max_width) ? text :
      text.scan(regex).join(zero_width_space)
end

class String
 def join
  self.split("_").map {|word| word.capitalize }.join("")
 end
end

str="<li>aaaaa_aaaaaaaaaaaaaaaaa_aaaaaaaaaaabbbbbbbbb_bbbbbbbbbbbbbbbbbbbbb_bccccccccccccccccccc_ccccccccccccccccccddddddddddddddddddd"
p "&#8203;"
p wrap(str)
p str.split("_")
p str.join

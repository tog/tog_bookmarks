Factory.define :user do |u|
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'pending'
  u.email {|a| "#{a.login}@example.com".downcase }
end

Factory.define :addresses do |addr|
  addr.description 'this is a site'
  addr.title {|a| "title_#{a.url}" }
end

Factory.define :bookmark do |b|
  b.address {|a| a.address }
  b.title {|a|  a.address.title }
  b.description {|a|  a.address.description } 
  b.owner {|a| a.user }
end

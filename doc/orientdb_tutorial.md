

> create database local:/tmp/databases/blog admin admin local graph
> use local:/tmp/databases/blog admin admin

# dropping class
drop class Customer





## https://github.com/orientechnologies/orientdb/wiki/SQL


create class Customer extends V
create vertex Customer set name = 'Luca'
select * from Customer






## orientdb4r


use local:/tmp/databases/blog admin admin



client.connect :database => 'local:/tmp/databases/blog', :user => 'admin', :password => 'admin'

require 'orientdb4r'
CLASS = 'myclass'

client = Orientdb4r.client  # equivalent for :host => 'localhost', :port => 2480, :ssl => false

client.database_exists? :database => 'temp', :user => 'admin', :password => 'admin'
client.connect :database => 'temp', :user => 'admin', :password => 'admin'
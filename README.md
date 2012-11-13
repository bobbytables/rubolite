rubolite
========

Rubolite is an interface to Gitolite (https://github.com/sitaramc/gitolite)

This is a work in progress. It's end goal is to give a full interface to interact with Gitolite and save changes.

```
>> admin = Rubolite::Admin.new("/Users/robertross/Sites/gitolite-admin")
=> #<Rubolite::Admin:0x007f96be332de8 @path="/Users/robertross/Sites/gitolite-admin">
>> admin.parser.repos.first
=> #<Rubolite::Repo:0x007f96be347068 @name="gitolite-admin", @users=[#<Rubolite::User:0x007f96be346dc0 @name="gitolite", @permissions="RW+">]>
```
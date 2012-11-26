Rubolite
========

Rubolite is an interface to Gitolite (https://github.com/sitaramc/gitolite)

@robertoross


Usage
=====

```gem "rubolite"```

```ruby
admin = Rubolite::Admin.new("/Users/robertross/Sites/gitolite-admin")
client = admin.client
client.repos # Get a list of repos

repo = Rubolite::Repo.new("newrepository")
user = Rubolite::User.new("robert", "RW+")

repo.add_user user

client.add_repo repo

client.save_and_push!
```

### Wait what?

* Rubolite requires that you tell it where your admin repository is on your box. It does not bootstrap this for you. Gitolite must be setup.
* Once you have that, the Rubolite::Admin class returns a client object by calling ```admin.client```. You do most of your calls on this interface.
* To get a list of repos in the current config, call ```client.repos```
* To add a repository to your config, insantiate a Repo object with a name.
* Repo objects take users which are instantiated with a name and permission level. Example: ```user = Rubolite::User.new("robert", "RW+")```
* Then we add the user to the repo with ```Repo#add_user```
* Then we add the repo to the client with ```Client#add_repo```

Calling ```save_and_push!``` does the following:

* Writes the new configuration file.
* Saves any SSH Keys you may have added (see below)
* Commits the changes to the gitolite-admin repo
* Pushes them to your origin remote.

If you really desire, you may call the methods individually. The methods are:

* ```save!``` Writes the config.
* ```save_ssh_keys!``` Writes SSH keys that may have been added.
* ```commit!``` Commits the changes on gitolite-admin.
* ```push!``` Pushes the repository to origin master.

### Dealing with SSH Keys

SSH Keys are handled by the Rubolite::SSHKey object.

#### From a string

```ruby
ssh_key = Rubolite::SSHKey.from_string("ssh-rsa awesomekeyprint robertross@local")
```

#### From a file

```ruby
ssh_key = Rubolite::SSHKey.from_file("~/.ssh/id_rsa.pub")
```

### Adding them to a gitolite-admin repo

Call ```add_ssh_key``` on your client with 2 parameters: username, and the ssh key object.

Your username must be the same name as the Rubolite::User name you add to repositories.

```ruby
repo = Rubolite::Repo.new("new-repo")
repo.add_user Rubolite::User.new("robert", "RW+")
client.add_ssh_key "robert", ssh_key
```
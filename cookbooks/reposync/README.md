kernel-modules Cookbook
=======================

[![Cookbook Version][cookbook_version]][cookbook]
[![Build Status][build_status]][build_status]

Mirror rpm repository with `reposync`.

Requirements:
-------------
### Platforms
* Centos 6.x/7.x
* Rhel 6.x/7.x

### Chef
* Chef version: >= 12.5.1

Attributes
----------
#### kernel_modules
* `node['reposync']['prefix']` - use to set configuration directory (Default: `/etc/reposync.d`)
* `node['reposync']['dest_dir']` - use to define where to store the Mirror

Usage
-----
Using this cookbook will mirror any rpm repository based on the tool `reposync`.

The `default` recipe is a requirement before using the provider.

For instance:
``` ruby
include_recipe 'reposync'
reposync_mirror 'couchbase' do
  repofile 'http://packages.couchbase.com/rpm/couchbase-centos62-x86_64.repo'
  update 'chef'
end
```

Providers & Resources
---------------------
## reposync_mirror
This provider allows to mirror a rpm repository

### Actions
Action   | Description
---------|---------------------------
create | Create a mirror
delete | Remove a mirrorred repository


### Property
Name | Description | Default| Type
-----|-------------|--------|-----
`reponame`| repository name| **name** | _String_
`repofile`| In case the repository maintainer already provides a repository file | **nil** | _URL identifier_
`baseurl` | In case the repository uses a baseurl| **nil** | _URL identifier_
`cookbook`| The cookbook where to find the template for the reposync configuration| **cookbook** | _String_
`update`| The repository refresher method| **daily** | See _Refreshers Methods_
`hour` | The hour when to run the refresher if not launched by chef| * | _String_
`minute` | The minute when to run the refresher if not launched by chef| **0** | _String_
`weekday` | The weekday when to run the refresher if not launched by chef| **0** | _String_
`timeout` | The timeout before stopping the mirrorring| **7200** | _String_
`remove_repo` | Define if a repository has be removed once it is deleted| **true** | _Boolean_
`conf_dir` | Define configuration directory| **/etc/reposync.d** | _String_
`dest_dir` | Define destination directory| **/var/opt/reposync** | _String_
`cmd_args` | Define additional command line arguments| **nil** | _[String, nil]_



**References**:
* The `URL identifier` are defined as follow:

Protocol| Definition
--------|-----------
HTTP URL| `http://`
FTP URL | `ftp://`
File    | `file://`

* Refresher Methods

Name | Frequence
-----|----------
`daily`| Once a daily
`weekly`| Once a weekly
`chef`| Every chef run


For instance:
``` ruby
# To mirror PowerDNS repositories at every chef run
include_recipe 'reposync'
reposync_mirror 'PowerDNS Auth 40' do
  repofile 'https://repo.powerdns.com/repo-files/centos-auth-40.repo'
  update 'chef'
end

default['reposync_config']['mirror'] = {
  'couchbase'         => {
    repofile: 'http://packages.couchbase.com/rpm/couchbase-centos62-x86_64.repo',
    weekday:  '*',
  },
  'grafana-7'         => {
    baseurl: 'https://packagecloud.io/grafana/stable/el/7/x86_64',
    weekday: '*',
  },
}

node['reposync_config']['mirror'].each do |repo_name, repo_config|
  reposync_mirror repo_name do
    repo_config.each do |k, v|
      instance_variable_set "@#{k}", v
    end
  end
end

```
Contributing
------------
1. Fork the [repository on Github][repository]
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Authors
-------------------
Authors: [Jeremy Mauro][author] (<j.mauro@criteo.com>)

```text
Copyright 2014-2015, Criteo.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[author]:                   https://github.com/jmauro
[repository]:               https://github.com/criteo-cookbooks/reposync
[build_status]:             https://api.travis-ci.org/criteo-cookbooks/reposync.svg?branch=master
[cookbook_version]:         https://img.shields.io/cookbook/v/reposync.svg
[cookbook]:                 https://supermarket.chef.io/cookbooks/reposync

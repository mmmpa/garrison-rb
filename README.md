[![Build Status](https://travis-ci.org/mmmpa/garrison.svg)](https://travis-ci.org/mmmpa/garrison)
[![Coverage Status](https://coveralls.io/repos/mmmpa/garrison/badge.svg?branch=master&service=github)](https://coveralls.io/github/mmmpa/garrison?branch=master)

[![Code Climate](https://codeclimate.com/github/mmmpa/garrison/badges/gpa.svg)](https://codeclimate.com/github/mmmpa/garrison)
[![Code Climate issues](https://codeclimate.com/github/mmmpa/garrison/badges/issue_count.svg)](https://codeclimate.com/github/mmmpa/garrison)

# 以下、書きかけ。

# Garrison

Supply methods for authorization.

# Installation

```ruby
gem 'garrison'
```

```
$ bundle install
```

# Usage

## Checker.

For example, a checker for **ModelA**.

```ruby
class ModelA
  attr_accessor :name, :owner_name

  def initialize(name:, owner_name:)
    self.name = name
    self.owner_name = owner_name
  end

  def act
    'acted'
  end

  def act2
    'acted'
  end
end
```

```ruby
class ModelAChecker < Garrison::Checker
  def can_act?
    user.name == obj.owner_name
  end

  def can_act2?
    user.name == obj.name
  end
end
```


Checker class name is "#{target class name}Checker".

Checker method name is "can_#{method name}?" and return boolean.

Garrison::Checker provides methods are `user` and `obj`. `user` and `obj` are set when a Checker Class instanced.

## Authorize

### Create a user and a keeper for the user.

```ruby
class User
  attr_accessor :name

  def initialize(name:)
    self.name = name
  end
end
```

```ruby
user = User.new(name: 'mmmpa')
keeper = Garrison::Keeper.new(user)
```

### Check.

```ruby
model = ModelA.new(name: 'model a', owner_name: user.name)
```

```ruby
keeper.(model).act #=> "acted"
```

`can_act?` is called and return `true`, then **model** excute a method **act**.

```ruby
keeper.(model).act2 #=> raise Garrison::Forbidden
```

`can_act2?` is called and return `false`, then **keeper** raise a exception.

# Auto Locking ActiveRecord

## Initialize

For all ActiveRecords.

```ruby
Garrison.lock!
```

For specific ActiveRecords.

```ruby
Garrison.lock! ModelA, ModelB
```

## Locked

```ruby
ModelA.new.save #=> raise Garrison::Locked
```

## Unlock

### With a keeper.

```ruby
model = ModelA.new
keeper.(model).save #=> true
```

### Without a keeper.

```ruby
model = ModelA.new
model.garrison.unlock
model.save #=> true
```

or

```ruby
ModelA.create(garrison_locked: false) #=> ModelA
```

# Route Constraint

Require implement a method `user`.

```ruby
class ConstraintA < Garrison::ConstraintAbstract
  def user
    ConstraintCurrentUser.user
  end
end
```

In `routes.rb`.

```ruby
scope constraints: ConstraintA.new do
  get 'a' => 'direct#index'
  patch 'a' => 'direct#update'
end
```

And a checker for `DirectController`.

```ruby
class DirectRouteChecker < Garrison::RouteCheckerAbstract
  def can_index?
    user.name == 'constraint'
  end

  def can_update?
    user.name == 'admin'
  end
end
```

## Like a guard section

```ruby
class GuardConstraint < Garrison::ConstraintAbstract
  def user
    ConstraintCurrentUser.user
  end

  def for_guard
    true
  end
end
```

```ruby
scope constraints: GuardConstraint.new do
  post 'any' => 'forbidden#create'
  post 'other' => 'forbidden#create_other'
end
```

```ruby
class ForbiddenRouteChecker < Garrison::RouteCheckerAbstract
  def block_create?
    user.name != 'admin'
  end

  def block_create_other?
    user.name != 'admin'
  end
end
```

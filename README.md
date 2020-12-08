# UniPg

Compatibility layer for pg and pg2.

# Features

### Switching between `pg` and `pg2`
UniPg automatically delegates to `pg` for OTP >= 23 and fallback to `pg2` for OTP < 23.

### Implicit scope, group creation.
* `:pg.start_link(scope)` is automatically called for scope access.
* `:pg2.create(group)` is automatically called for group access.

Calling scope/group creation everytime introduces performance penalty. 
But it's so small(< 10ns) that most applications can ignore it for programmers's convenience.

### `scope` for `pg2`
Emulates `pg`'s `scope` API for `pg2`.

## Usage

```console
iex(1)> UniPg.join(:scope1, :group1, [self()])
:ok
iex(2)> UniPg.get_members(:scope1, :group1)
[#PID<0.179.0>]
iex(3)> UniPg.which_groups(:scope1)        
[:group1]
iex(4)> UniPg.leave(:scope1, :group1, [self()])
:ok
iex(5)> UniPg.get_members(:scope1, :group1)    
[]
```
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `uni_pg` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:uni_pg, "~> 0.1.0"}
  ]
end
```

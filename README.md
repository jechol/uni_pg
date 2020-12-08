
[![mix test](https://github.com/jechol/uni_pg/workflows/mix%20test/badge.svg)](https://github.com/jechol/uni_pg/actions)
[![Hex version badge](https://img.shields.io/hexpm/v/uni_pg)](https://hex.pm/packages/uni_pg)
[![License badge](https://img.shields.io/hexpm/l/uni_pg)](https://github.com/jechol/uni_pg/blob/master/LICENSE.md)
# UniPg

Compatibility layer for pg and pg2.

## Features

### 1. Unified API on top of `pg` and `pg2`.
UniPg provides API similar to `pg` and implemented on top of
* `pg` for OTP >= 23.
* `pg2` for OTP < 23.

### 2. Emulates `scope` for `pg2`
Emulates `pg`'s `scope` parameter for `pg2`.

### 3. Implicit scope and group creation.
* `:pg.start_link(scope)` is automatically called for scope access.
* `:pg2.create(group)` is automatically called for group access.

Calling scope/group creation everytime introduces performance penalty. 
But it's so small(< 10ns) that most applications can ignore it for the sake of convenience.

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


[![mix test](https://github.com/jechol/uni_pg/workflows/mix%20test/badge.svg)](https://github.com/jechol/uni_pg/actions)
[![Hex version badge](https://img.shields.io/hexpm/v/uni_pg)](https://hex.pm/packages/uni_pg)
[![License badge](https://img.shields.io/hexpm/l/uni_pg)](https://github.com/jechol/uni_pg/blob/master/LICENSE.md)
# UniPg

Compatibility layer for pg and pg2.

## Why?

`pg` was introduced at OTP 23, and `pg2` is deprecated and will be removed at OTP 24.

| OTP version | 22 | 23 | 24 |
|-------------|----|----|----|
| pg          | X  | O  | O  |
| pg2         | O  | O  | X  |


This means that you shouldn't directly depend on `pg` or `pg2` if you wish your code to work with wide range of OTP versions.


## Features

### 1. Unified API on top of `pg` and `pg2`.
UniPg provides API similar to `pg` and implemented on top of
* `pg` for OTP >= 23.
* `pg2` for OTP < 23.

### 2. `scope` emulation for `pg2`
`scope` is new concept introduced by `pg`, so it is emulated for `pg2`.

### 3. Implicit scope and group creation.
* `:pg.start_link(scope)` is called before scope access.
* `:pg2.create(group)` is called before group access.

Calling scope/group creation everytime introduces performance penalty. 
But it's so small(< 5μs on my MBP 2015) that most applications can ignore it for the sake of convenience.

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
    {:uni_pg, "~> 0.2.0"}
  ]
end
```

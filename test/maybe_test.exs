defmodule MaybeTest do
  use ExUnit.Case, async: true
  import Monad
  import Monad.Maybe

  test "Monad.Maybe left identity" do
    f = fn (x) -> x * x end
    a = 2
    assert bind(return(a), f) == f.(a)
  end

  test "Monad.Maybe right identity" do
    m = return 42
    assert bind(m, &return/1) == m
  end

  test "Monad.Maybe associativity" do
    f = fn (x) -> x * x end
    g = fn (x) -> x - 1 end
    m = return 2
    assert bind(return(bind(m, f)), g) == bind(m, &bind(return(f.(&1)), g))
  end

  test "Monad.Maybe successful bind" do
    assert (m Monad.Maybe do
              x <- just 2
              y <- just 4
              return (x * y)
            end) == {:just, 8}
  end

  test "Monad.Maybe failing bind" do
    assert (m Monad.Maybe do
              x <- just 2
              y <- fail "Yes, we can"
              return (x * y)
            end) == :nothing
  end

  test "Monad.Maybe.maybe/3 with just value" do
    assert maybe(1, &(&1 + &1), just 2) == 4
  end

  test "Monad.Maybe.maybe/3 with nothing value" do
    assert maybe(1, &(&1 + &1), nothing) == 2
  end
  test "Monad.Maybe.is_just/1 with just value" do
    assert is_just(just :whatever)
  end

  test "Monad.Maybe.is_just/1 with nothing value" do
    refute is_just(nothing)
  end

  test "Monad.Maybe.is_nothing/1 with nothing value" do
    assert is_nothing(nothing)
  end

  test "Monad.Maybe.is_nothing/1 with just value" do
    refute is_nothing(just :whatever)
  end

  test "Monad.Maybe.from_just/1 with just value" do
    assert from_just(just :value) == :value
  end

  test "Monad.Maybe.from_just/1 with nothing value" do
    assert_raise RuntimeError, fn () -> from_just(nothing) end
  end

  test "Monad.Maybe.from_maybe/2 with just value" do
    assert from_maybe(:default, just :value) == :value
  end

  test "Monad.Maybe.from_maybe/2 with nothing value" do
    assert from_maybe(:default, :nothing) == :default
  end

  test "Monad.Maybe.maybe_to_list/1 with just value" do
    assert maybe_to_list(just :value) == [:value]
  end

  test "Monad.Maybe.maybe_to_list/1 with nothing value" do
    assert maybe_to_list(nothing) == []
  end

  test "Monad.Maybe.list_to_maybe/1 with non-empty list" do
    assert list_to_maybe([:value, :another_value]) == just :value
  end

  test "Monad.Maybe.list_to_maybe/1 with empty list" do
    assert list_to_maybe([]) == nothing
  end

  test "Monad.Monad.cat_maybes/1" do
    assert cat_maybes([nothing, just(1), nothing, just(2), just(3)]) ==
      [1, 2, 3]
  end
end

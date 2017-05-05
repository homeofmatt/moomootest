require "./moomootest.rb"

class TestAssertions < MooMooTest
  def test_assert
    assert true
  end

  def test_assert_equal
    assert_equal 4, 2+2
  end

  def test_assert_in_delta
    assert_in_delta 0.0001, 0.0002
  end

  def test_assert_failure
    assert 1 == 2
  end

  def test_assert_equal_failure
    assert_equal 5, 2+2
  end

  def test_assert_in_delta_failure
    assert_in_delta 0.5, 0.6
  end
end

TestAssertions.run_all_tests
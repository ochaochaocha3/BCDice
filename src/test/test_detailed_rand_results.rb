# -*- coding: utf-8 -*-

require 'test/unit'
require 'bcdiceCore'

# ダイスロール結果詳細のテストケース
# 10の位用にダイスロールした場合などの確認
class TestDetailedRandResults < Test::Unit::TestCase
  def setup
    @bcdice = BCDiceMaker.new.newBcDice
    @bcdice.setCollectRandResult(true)
  end

  def test_rand
    @bcdice.setRandomValues([[49, 100]])

    value = @bcdice.rand(100)

    assert_equal(49 - 1, value)

    assert_equal(1, @bcdice.getDetailedRandResults.size)
    assert_equal("100", @bcdice.getDetailedRandResults[0][1])
    assert_equal(49, @bcdice.getDetailedRandResults[0][0])

    assert_equal(1, @bcdice.getRandResults.size)
    assert_equal(100, @bcdice.getRandResults[0][1])
    assert_equal(49, @bcdice.getRandResults[0][0])
  end

  def test_tens_d10
    @bcdice.setRandomValues([[3, 10]])
    value = @bcdice.roll_tens_d10()

    assert_equal(30, value)

    assert_equal(1, @bcdice.getDetailedRandResults.size)
    assert_equal("tens_d10", @bcdice.getDetailedRandResults[0][1])
    assert_equal(30, @bcdice.getDetailedRandResults[0][0])

    assert_equal(1, @bcdice.getRandResults.size)
    assert_equal(10, @bcdice.getRandResults[0][1])
    assert_equal(3, @bcdice.getRandResults[0][0])
  end

  def test_tens_d10_zero
    @bcdice.setRandomValues([[10, 10]])
    value = @bcdice.roll_tens_d10()

    assert_equal(0, value)
    assert_equal(0, @bcdice.getDetailedRandResults[0][0])
    assert_equal(10, @bcdice.getRandResults[0][0])
  end

  def test_d9
    @bcdice.setRandomValues([[3, 10]])
    value = @bcdice.roll_d9()

    assert_equal(2, value)

    assert_equal(1, @bcdice.getDetailedRandResults.size)
    assert_equal("d9", @bcdice.getDetailedRandResults[0][1])
    assert_equal(2, @bcdice.getDetailedRandResults[0][0])

    assert_equal(1, @bcdice.getRandResults.size)
    assert_equal(10, @bcdice.getRandResults[0][1])
    assert_equal(3, @bcdice.getRandResults[0][0])
  end
end

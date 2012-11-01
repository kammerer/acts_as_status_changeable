require "test_helper"


class ActsAsStatusChangeableTest < Test::Unit::TestCase

  class Gizmo < ActiveRecord::Base
    acts_as_status_changeable :status
  end

  def setup
    Gizmo.delete_all
  end

  def test_status_changes_method
    gizmo = Gizmo.create!(:status => "ok")
    assert gizmo.respond_to?(:status_changes)

    gizmo.status_changes.first.tap do |change|
      assert_equal ActsAsStatusChangeable::StatusChange, change.class
      assert_equal "status", change.status_name
      assert_equal "ok", change.status
      assert_equal gizmo.id, change.status_changeable.id
      assert_equal gizmo.class.name, change.status_changeable_type
      assert_equal gizmo, change.status_changeable
      assert change.created_at >= gizmo.created_at
      assert change.created_at < Time.now
    end
  end

  def test_was_in_status_method
    gizmo = Gizmo.create!(:status => "new")
    assert gizmo.respond_to?(:was_in_status?)
    assert gizmo.was_in_status?(:status, :new)
    assert gizmo.was_in_status?(:status, "new")
    assert ! gizmo.was_in_status?(:status, :broken)
  end

  def test_status_date_method
    times = [1.year.ago, 1.day.ago]

    gizmo = Gizmo.create!(:status => "ok")
    gizmo.update_attributes!(:status => "broken")
    gizmo.update_attributes!(:status => "ok")

    gizmo.status_changes.where(:status_name => "status").order("id").first.update_attribute(:created_at, times[0])
    gizmo.status_changes.where(:status_name => "status").order("id").last.update_attribute(:created_at, times[1])

    assert gizmo.respond_to?(:status_date)
    assert_equal times[1], gizmo.status_date(:status, "ok")
  end

  def test_with_past_status_scope
    assert Gizmo.respond_to?(:with_past_status)

    3.times { Gizmo.create!(:status => "ok") }
    2.times { Gizmo.create!(:status => "broken") }
    1.times { Gizmo.create!(:status => "unknown") }

    assert_equal 3, Gizmo.with_past_status(:status, :ok).count
    assert_equal 2, Gizmo.with_past_status(:status, :broken).count
    assert_equal 5, Gizmo.with_past_status(:status, %w[ok broken]).count
  end

end


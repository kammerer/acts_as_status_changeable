ActsAsStatusChangable
=====================

This gem provides the facility to automatically track history of changes in +activerecord+ models built around the concept of state machine.


Model
-----

Firstly, enable tracking in the model(s):

      class Gizmo < ActiveRecord::Base
        acts_as_status_changeable :status, :other_status
      end

      class Thingamabob < ActiveRecord::Base
        acts_as_status_changeable :status
      end

Changes of these attributes will be persisted in `status_changes` table. 


Examples
--------

      Gizmo.with_past_status(:other_status, "broken").count

      gizmo = Gizmo.create!(:status => :new)
      gizmo.status_changes.last.inspect # => #<ActsAsStatusChangeable::StatusChange id: 1, status_changeable_id: 1,
                                        # status_changeable_type: "Gizmo", status_name: "status", status: "new",
                                        # created_at: "2012-11-01 17:58:15", updated_at: "2012-11-01 17:58:15">

      gizmo.was_in_status?(:status, :new) # => true
      gizmo.status_date(:status, :new) # => time of most recent transition to given status


Migration
---------

This gem provides migration class which can be reused as follows:

      class CreateStatusChanges < ActsAsStatusChangeable::Migration
      end



Copyright (c) 2009-2012 Radosław Bułat, Tomasz Szymczyszyn, released under the MIT license 


require "test_helper"

class EventTest < ActiveSupport::TestCase
  def test_create_event_as_admin_user
    event = users(:farnsworth).create_event!({ name: "An event",
                                               date: "4/22/2015",
                                               start_time: "7:00 pm",
                                               end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert event.listed?, "Admin created events default to listed"
    assert_equal "An event", event.name
    assert_nil event.anonymous_user_ip, "Admin ip is not stored when creating an event"
  end

  def test_create_event_as_normal_user
    event = users(:fry).create_event!({ name: "An event",
                                        date: "4/22/2015",
                                        start_time: "7:00 pm",
                                        end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert event.listed?, "Registered user created events default to listed"
    assert_equal "An event", event.name
    assert_nil event.anonymous_user_ip, "User ip is not stored when creating an event"
  end

  def test_create_event_as_anonymous
    event = Anonymous.user.create_event!({ name: "An event",
                                           date: "4/22/2015",
                                           start_time: "7:00 pm",
                                           end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert_not event.listed?, "Anonymously created events default to unlisted"
    assert_equal "An event", event.name
    assert_equal "127.0.0.1", event.anonymous_user_ip, "Anonymous ip is stored when creating an event"
  end

  def test_delete_event_as_admin_user
    event = events :tv_night
    users(:farnsworth).destroy_event! id: event.id.to_s
    event.reload
    assert event.deleted?, "Admin users can delete"
    assert_not_nil event.deleted_at, "Deleted at has been set"
    assert_equal users(:farnsworth), event.deleted_by, "Deleted by has been set"
  end

  def test_delete_event_as_normal_user
    event = events :tv_night

    assert_raises PermissionError do
      users(:fry).destroy_event! id: event.id.to_s
    end

    event.reload
    assert_not event.deleted?, "Normal users can't delete"
  end

  def test_delete_event_as_anonymous
    event = events :tv_night

    assert_raises PermissionError do
      Anonymous.user.destroy_event! id: event.id.to_s
    end

    event.reload
    assert_not event.deleted?, "Normal users can't delete"
  end

  def test_edit_event_as_owner
    event = events :tv_night
    users(:fry).edit_event! edit_event_params(event, description: "TV night, woohoo!")
    event.reload
    assert event.listed?, "Owner edited events are listed"
    assert_equal "TV night, woohoo!", event.description
  end

  def test_edit_event_as_non_owner
    event = events :tv_night

    assert_raises PermissionError do
      users(:leela).edit_event! edit_event_params(event, description: "TV night, woohoo!")
    end

    event.reload
    assert event.listed?, "The unedited event is unchanged"
    assert_not_equal "TV night, woohoo!", event.description
  end

  def test_edit_event_as_admin
    event = events :tv_night
    users(:farnsworth).edit_event! edit_event_params(event, description: "TV night, woohoo!")
    event.reload
    assert event.listed?, "Admin edited events are listed"
    assert_equal "TV night, woohoo!", event.description
  end

  def test_edit_event_as_anonymous
    event = events :robots_unite

    assert_raises PermissionError do
      Anonymous.user.edit_event! edit_event_params(event, description: "Robots, woohoo!")
    end

    event.reload
    assert event.listed?, "The unedited event is unchanged"
    assert_not_equal "Robots, woohoo!", event.description
  end

  private

  def edit_event_params(event, new_params)
    { id: event.id,
      name: event.name,
      coordinator: event.coordinator,
      coordinator_twitter: event.coordinator_twitter,
      url: event.url,
      location: event.location,
      description: event.description,
      date: event.edit_date,
      start_time: event.edit_start_time,
      end_time: event.edit_end_time }.merge(new_params)
  end
end

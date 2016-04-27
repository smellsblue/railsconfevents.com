require "test_helper"

class EventTest < ActiveSupport::TestCase
  def test_create_event_as_admin_user
    event = users(:farnsworth).create_event!({ name: "An event",
                                               date: "4/22/#{current_year}",
                                               start_time: "7:00 pm",
                                               end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert event.listed?, "Admin created events default to listed"
    assert_equal "An event", event.name
    assert_nil event.anonymous_user_ip, "Admin ip is not stored when creating an event"
  end

  def test_create_event_as_normal_user
    event = users(:fry).create_event!({ name: "An event",
                                        date: "4/22/#{current_year}",
                                        start_time: "7:00 pm",
                                        end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert event.listed?, "Registered user created events default to listed"
    assert_equal "An event", event.name
    assert_nil event.anonymous_user_ip, "User ip is not stored when creating an event"
  end

  def test_create_event_with_multiple_non_user_coordinators
    event = users(:fry).create_event!({ name: "An event",
                                        date: "4/22/#{current_year}",
                                        coordinators: ["John Doe", ""],
                                        coordinator_twitters: ["", "joandoe"],
                                        start_time: "7:00 pm",
                                        end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert_equal ["John Doe", ""], event.coordinators.map(&:name)
    assert_equal ["", "joandoe"], event.coordinators.map(&:twitter)
  end

  def test_ignore_empty_coordinators
    event = users(:fry).create_event!({ name: "An event",
                                        date: "4/22/#{current_year}",
                                        coordinators: ["", ""],
                                        coordinator_twitters: ["", ""],
                                        start_time: "7:00 pm",
                                        end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert event.coordinators.empty?
  end

  def test_create_event_with_self_as_coordinator
    event = users(:fry).create_event!({ name: "An event",
                                        date: "4/22/#{current_year}",
                                        coordinator_githubs: [users(:fry).username],
                                        start_time: "7:00 pm",
                                        end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert_equal [users(:fry)], event.coordinators.map(&:user)
  end

  def test_create_event_with_invalid_user
    event = users(:fry).create_event!({ name: "An event",
                                        date: "4/22/#{current_year}",
                                        coordinator_githubs: ["invalid"],
                                        start_time: "7:00 pm",
                                        end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert event.coordinators.empty?
  end

  def test_create_event_with_another_user_as_coordinator
    event = users(:fry).create_event!({ name: "An event",
                                        date: "4/22/#{current_year}",
                                        coordinator_githubs: [users(:farnsworth).username],
                                        start_time: "7:00 pm",
                                        end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert_equal [users(:farnsworth)], event.coordinators.map(&:user)
  end

  def test_create_event_with_multiple_user_coordinators
    event = users(:fry).create_event!({ name: "An event",
                                        date: "4/22/#{current_year}",
                                        coordinator_githubs: [users(:fry).username,
                                                              users(:farnsworth).username],
                                        start_time: "7:00 pm",
                                        end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert_equal [users(:fry), users(:farnsworth)], event.coordinators.map(&:user)
  end

  def test_create_event_as_anonymous
    event = Anonymous.user.create_event!({ name: "An event",
                                           date: "4/22/#{current_year}",
                                           start_time: "7:00 pm",
                                           end_time: "8:00 pm" }, "127.0.0.1")
    event.reload
    assert_not event.listed?, "Anonymously created events default to unlisted"
    assert_equal "An event", event.name
    assert_equal "127.0.0.1", event.anonymous_user_ip, "Anonymous ip is stored when creating an event"
  end

  def test_create_with_invalid_date
    assert_raises ActiveRecord::RecordInvalid do
      users(:fry).create_event!({ name: "An event",
                                  date: "4/17/#{current_year}",
                                  start_time: "7:00 pm",
                                  end_time: "8:00 pm" }, "127.0.0.1")
    end

    assert_raises ActiveRecord::RecordInvalid do
      users(:fry).create_event!({ name: "An event",
                                  date: "4/27/#{current_year}",
                                  start_time: "7:00 pm",
                                  end_time: "8:00 pm" }, "127.0.0.1")
    end
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

  def test_edit_event_with_invalid_date
    event = events :tv_night

    assert_raises ActiveRecord::RecordInvalid do
      users(:fry).edit_event! edit_event_params(event, date: "4/17/#{current_year}")
    end

    assert_raises ActiveRecord::RecordInvalid do
      users(:fry).edit_event! edit_event_params(event, date: "4/27/#{current_year}")
    end
  end

  def test_comment_as_normal_user
    event = events :tv_night
    users(:leela).comment_on_event! event_id: event.id.to_s, comment: "I'm in!"
    event.reload
    comment = event.comments.first
    assert_equal "I'm in!", comment.text
    assert_equal users(:leela), comment.creator
  end

  def test_comment_as_anonymous
    event = events :tv_night
    original_comment_count = event.comments.count

    assert_raises PermissionError do
      Anonymous.user.comment_on_event! event_id: event.id.to_s, comment: "I'm in!"
    end

    event.reload
    assert_equal original_comment_count, event.comments.count
  end

  private

  def edit_event_params(event, new_params)
    { id: event.id,
      name: event.name,
      coordinators: ([event.coordinators.first.name] unless event.coordinators.empty?),
      coordinator_twitters: ([event.coordinators.first.twitter] unless event.coordinators.empty?),
      url: event.url,
      location: event.location,
      description: event.description,
      date: event.edit_date,
      start_time: event.edit_start_time,
      end_time: event.edit_end_time }.merge(new_params)
  end
end

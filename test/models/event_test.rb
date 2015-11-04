require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test 'should not save event with title less 5' do
    event = Event.new(title: 'titl', recurrence: 'weekly', schedule: { start_time: '2016.01.01' })
    assert_not event.save
  end
end

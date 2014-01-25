require 'objspace'
require 'graph_data'

class Spaghetti
  def initialize
    @c = 10.times.map { Coupling1.new }
    @c2 = Coupling2.new
  end
end

class Coupling1
end

class Coupling2
end

class ApplicationController < ActionController::Base

  include Tubesock::Hijack

  protect_from_forgery with: :exception

  def test
    Spaghetti.new
    100.times {|n| "#{n}foo" }
    render text: 'create some string'
  end

  def object_space_scopes
    [Spaghetti]
  end

  def max_object_space_depth
    2
  end

  def start
    ActiveSupport::Notifications.subscribe('start_processing.action_controller') do |*args|
      GC.disable
    end
    ActiveSupport::Notifications.subscribe('process_action.action_controller') do |*args|
      if Rails.stream.connected?
        object_space_scopes.each do |scope|
          ObjectSpace.each_object(scope) do |obj|
            stream_object_data! obj, scope
          end
        end
      end
      GC.enable
      GC.start
    end
    head :ok
  end

  def stop
    ActiveSupport::Notifications.unsubscribe('start_processing.action_controller')
    ActiveSupport::Notifications.unsubscribe('process_action.action_controller')
    head :ok
  end

  def graph
  end

  def data
    hijack do |websocket|
      websocket.onopen do
        Rails.stream = Stream.new(websocket)
      end
      websocket.onclose do
        Rails.stream = Stream.new
      end
    end
  end

  private

  def stream_object_data!(obj, scope, depth=0)
    if depth >= max_object_space_depth
      references = []
    else
      references = ObjectSpace.reachable_objects_from(obj).map {|r| stream_object_data!(r, scope, depth + 1) }
    end
    ObjectData.new(scope.to_s, obj.class.to_s, obj.object_id, references).tap do |object_data|
      Rails.stream.write object_data.to_json unless object_data.klass == "Class"
    end
  end
end

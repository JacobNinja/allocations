# What is this?
This is a Rails application that plugs into Rails instrumentation to trace object allocation during the lifecycle of a request.
The trace data will be streamed to your browser and graphed real time in D3.
Keep in mind this is a proof of concept!

# Why does this exist?
This is just a simple rails application right now, but the goal is to make it a mountable rails engine. 
Doing so will enable real time allocation profiling of YOUR rails application.

## Recommended:
1. Ruby 2.1
2. Lots of RAM

## Setup:
1. `bundle install`
2. `rails s`

## How do I get started?
1. Load `http://localhost:3000`
2. Click 'Start instrumentation'
3. Review graph; nodes represent objects, edges represent references. The thicker the edge, the more references between objects.
4. Click 'Test'
5. Notice how the graph aggregates data over many requests...lines get thicker.

## How do I profile something else?
Be careful not to broaden the scope or depth of recursion too much. Currently, it is easy to overload your browser with events.
* `ApplicationController#test` is the code executed when clicking 'Test'.
* `ApplicationController#object_space_scope` will scope the graph to only the descendants of the class provided.
* `ApplicationController#max_object_space_depth` determines how many levels of recursion to profile from `object_space_scope`.

## TODO
* Buffer streamed events to reduce websocket overload.

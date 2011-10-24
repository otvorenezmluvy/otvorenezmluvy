require 'new_relic/agent/method_tracer'

ElasticRecordIndex.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :search
end
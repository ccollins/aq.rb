guard 'rspec', :all_on_start => false, :all_after_pass => false, :version => 2, :keep_failed => false, :cli => "--color --format nested --drb" do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }

  # Rails example
  watch('spec/spec_helper.rb')                       { "spec" }
  watch('app/controllers/application_controller.rb') { "spec/controllers" }
  watch('config/routes.rb')                          { ["spec/routing", "spec/requests"] }
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
end

guard 'bundler' do
  watch('Gemfile')
end